<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <html>

    <head>
      <title>Json Files</title>
    </head>

    <body>
      <script src="https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js"></script>
      <div>
        <ul>
          <c:forEach items="${jsonFiles}" var="jsonFile">
            <li>
              <details>
                <summary>${jsonFile.getName()}</summary>
                <pre class="prettyprint"><code>${jsonFile.getContent()}</code></pre>
              </details>
            </li>
          </c:forEach>
        </ul>
      </div>
    </body>

    </html>