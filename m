From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [PATCH 8/8] [CRYPTO] aead: Add support for multiple template parameters
Date: Thu, 27 Sep 2007 17:25:45 -0500
Message-ID: <200709272225.l8RMPjb5003200@faith.austin.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:52045 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbXI0W3f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2007 18:29:35 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8RMTYnJ000750
	for <linux-crypto@vger.kernel.org>; Thu, 27 Sep 2007 18:29:34 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8RMTYem372926
	for <linux-crypto@vger.kernel.org>; Thu, 27 Sep 2007 16:29:34 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8RMTX2b019034
	for <linux-crypto@vger.kernel.org>; Thu, 27 Sep 2007 16:29:34 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

My apologies for such late notice, but I observed this only recently
and wanted to point it out. 


 	if (!try_module_get(THIS_MODULE))
 		goto err;
@@ -101,33 +106,73 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 
 	memcpy(param->template, name, len);
 
-	name = p + 1;
-	len = 0;
-	for (p = name; *p; p++) {
-		for (; isalnum(*p) || *p == '-' || *p == '_' || *p == '('; p++)
-			;
+	i = 0;
+	for (;;) {
+		int notnum = 0;
 
-		if (*p != ')')
-			goto err_free_param;
+		name = ++p;
+		len = 0;
+
+		for (; isalnum(*p) || *p == '-' || *p == '_'; p++)
+			notnum |= !isdigit(*p);
+
+		if (*p == '(') {
+			int recursion = 0;
+
+			for (;;) {
+				if (!*++p)
+					goto err_free_param;
+				if (*p == '(')
+					recursion++;
+				else if (*p == ')' && !recursion--)

Shouldn't p be incremented after this check? Otherwise, it will 
still be pointing to ')' after breaking from this for-loop and we will
end up copying "hmac(sha1" instead of "hmac(sha1)", right?
Also, I think we will prematurely break from top for-loop 
because of check, "if (*p == ')') break;" which is done further down...

+					break;
+			}
+
+			notnum = 1;
+		}
 
 		len = p - name;
+		if (!len)
+			goto err_free_param;
+
+		if (notnum) {
+			param->attrs[i].alg.attr.rta_len =
+				sizeof(param->attrs[i].alg);
+			param->attrs[i].alg.attr.rta_type = CRYPTOA_ALG;
+			memcpy(param->attrs[i].alg.data.name, name, len);
+		} else {
+			param->attrs[i].nu32.attr.rta_len =
+				sizeof(param->attrs[i].nu32);
+			param->attrs[i].nu32.attr.rta_type = CRYPTOA_U32;
+			param->attrs[i].nu32.data.num =
+				simple_strtol(name, NULL, 0);
+		}
+
+		param->tb[i + 1] = &param->attrs[i].attr;
+		i++;
+
+		if (WARN_ON(i >= CRYPTO_MAX_ATTRS))
+			goto err_free_param;
+
+		if (*p == ')')
+			break;
+
+		if (*p != ',')
+			goto err_free_param;
 	}


Regards,
Joy
