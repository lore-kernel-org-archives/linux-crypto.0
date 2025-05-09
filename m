Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19198287500;
	Fri,  9 May 2025 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746786253; cv=none; b=mHgYYcaZoL20u+sw8W45QPY9pYjetzofKE3OpawZE8fDsZdo+pNShqLBIW9DbsQgRed5J2YST4vXIVmMwePSYWPhDIS7fWIjhGRMRPfUyuNLwMCo137QmGLYspO9tZZOA8fPT5lEmWNQyjpPZrnwcmzJs4lv26XAmMQ2ljxQVM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746786253; c=relaxed/simple;
	bh=Mv/7zMBiwb5gAMPkPyBbHEzvG1xCA85ECVJWhXZm6uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luCBuvMP//IVThbzPuHQZiet0wUGto8eozHKvQGk8D7eLzWpMurrFMcnBJUmYuX6+GcN5Pk9lvhfGh/IkuRApTDJrzdBDEXoVPv7Y0BNR98bbAlW3RkpICGzeLH9qe4zDp6W/AxMayiOEmDLfaCfjoYXnIBZULmYgdfKQF/DYbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tpkdO9Bt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tpkdO9Bt"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5494Bx6m029630;
	Fri, 9 May 2025 10:24:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1rYnEf9GN9FWsJos4
	3c2Xr4krI+XIdkOBGcoTSPTg34=; b=tpkdO9BtEuVmNDxBEEXrSuvx7djqExkig
	xnH3wv9FtLULDFwKHza75WyaaOv5dM6hVpgSqJ54fyND+ziySv5qYF8hjgBwBhJG
	YFezALcAjlNnlqdhqlx4mnAVuSzplNRuTjFog+OVemExayYfTa5hsp2rxjNBODNm
	7GhvSqrbpA0zDiIGZVYzvcOt6ydAkFDLOx4dZRdymkfH93YvsaSxnyAFqqXYk1qf
	ByVkv2UuAgbxXD9kJES85aUnWAL7EaNAI6xEEdZRWsOlrHN2ECsM06Ej5UtgVIgT
	eYQSx79Vxfvta04AbY21eOw2e9mmEbSL1WozaWc7biP/vin1RthUQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46h6k0jr41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 10:24:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5499nM30014583;
	Fri, 9 May 2025 10:24:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46dypm2m2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 10:24:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 549AO4aL52822524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 May 2025 10:24:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF20220040;
	Fri,  9 May 2025 10:24:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B45C12004E;
	Fri,  9 May 2025 10:24:03 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.70.163])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  9 May 2025 10:24:03 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com,
        fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v4 3/3] Documentation: crypto_engine: Update and extend crypto engine doc
Date: Fri,  9 May 2025 12:24:02 +0200
Message-ID: <20250509102402.27287-4-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250509102402.27287-1-freude@linux.ibm.com>
References: <20250509102402.27287-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8NqhmbDcAj9lXWvOqHuQ0R84xsEsz0Yx
X-Proofpoint-ORIG-GUID: 8NqhmbDcAj9lXWvOqHuQ0R84xsEsz0Yx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDA5NyBTYWx0ZWRfXwXWfGi2xdgnc 0aiG6vLa6oXBO2OJ7g6HkzNZXnVPT1icsiTHG1rYU8xH7cAn9xw8tXUJTI8D4TLAPUvrUwjHssI g1HZ+YhlMr1L3KHjBDNkJuYGu7OQ9TDkIeKStbR+HWp2k3mViwKgAlVhEjpeHdKSqskk0ecTa1t
 KKNvffdkMjdLaeWX0tfcKMBnNfgu8jkTB/xF33mvm6j31ubvsoxsVeevQAS0MQJu0SzwtoxkRV9 hHhzMWZJJ2n0lIgqzPoMUJT34SVmH+CkGbL8r3rVNxCabDkKbUduMek4ClJU+ySkBSgNEcnDI58 SV64kAuZfENuySkkvprOqj3gAnWVL1Qs9qwqWl0xddL0HVeH/oVjpa68liioMf/gLixrZ8VWu7o
 80nidC/Al64f1KvY6FYS2R3JlpvnwQdJKuiJ0nMWAsB8BRqvzAzBpiEKZ+l2gXVX8AbGfKfP
X-Authority-Analysis: v=2.4 cv=OcCYDgTY c=1 sm=1 tr=0 ts=681dd7c8 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=xi-NTiZ_wNmCx6O0tBcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_04,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505090097

Remove outdated wording about crypto engine context.
Rephrase and extend the usage of the crypto engine.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 Documentation/crypto/crypto_engine.rst | 78 ++++++++++++--------------
 1 file changed, 36 insertions(+), 42 deletions(-)

diff --git a/Documentation/crypto/crypto_engine.rst b/Documentation/crypto/crypto_engine.rst
index d562ea17d994..3665d8062c07 100644
--- a/Documentation/crypto/crypto_engine.rst
+++ b/Documentation/crypto/crypto_engine.rst
@@ -6,25 +6,35 @@ Crypto Engine
 Overview
 --------
 The crypto engine (CE) API is a crypto queue manager.
+It is the in-kernel crypto way to enqueue asynchronous crypto requests
+instead of instantiating your own workqueue.
 
 Requirement
 -----------
-You must put, at the start of your transform context your_tfm_ctx, the structure
-crypto_engine:
-
-::
-
-	struct your_tfm_ctx {
-		struct crypto_engine engine;
-		...
-	};
-
-The crypto engine only manages asynchronous requests in the form of
-crypto_async_request. It cannot know the underlying request type and thus only
-has access to the transform structure. It is not possible to access the context
-using container_of. In addition, the engine knows nothing about your
-structure "``struct your_tfm_ctx``". The engine assumes (requires) the placement
-of the known member ``struct crypto_engine`` at the beginning.
+For registration with the use of an crypto engine instance the
+transformation needs to implement the respective ``struct *_engine_alg``.
+For example a skcipher transformation implements
+``struct skcipher_engine_alg``. This struct consists of the usual
+transformation struct (for example ``struct skcipher_alg``) plus a
+``struct crypto_engine_op`` which provides the callback used by the
+crypto engine to run the asynchronous requests.
+
+The transformation implements the callback function
+``int (*do_one_request)(struct crypto_engine *engine, void *areq)``.
+This callback is invoked by the engine to process asynchronous
+requests which have been previously pushed to the engine with one of
+the ``crypto_transfer_*_request_to_engine()``.
+The ``do_one_request()`` implementation needs to handle the request
+and on successful processing completes the request with a call to
+``crypto_finalize_*_request()`` and a return value of 0. A return
+value other than 0 indicates an error condition and the request is
+unsuccessful marked as completed with this error value by the engine.
+A special treatment is done for the return value ``-ENOSPC``. At
+allocation of the engine instance via
+``crypto_engine_alloc_init_and_set(..., bool retry_support, ...)``
+with the ``retry_support`` parameter set to true, the engine instance
+handles the ``-ENOSPC`` by re-queuing the request into the backlog and
+at a later time the callback is invoked again to process this request.
 
 Order of operations
 -------------------
@@ -33,35 +43,19 @@ Start it via ``crypto_engine_start()``. When finished with your work, shut down
 engine using ``crypto_engine_stop()`` and destroy the engine with
 ``crypto_engine_exit()``.
 
-Before transferring any request, you have to fill the context enginectx by
-providing functions for the following:
-
-* ``prepare_crypt_hardware``: Called once before any prepare functions are
-  called.
-
-* ``unprepare_crypt_hardware``: Called once after all unprepare functions have
-  been called.
-
-* ``prepare_cipher_request``/``prepare_hash_request``: Called before each
-  corresponding request is performed. If some processing or other preparatory
-  work is required, do it here.
-
-* ``unprepare_cipher_request``/``unprepare_hash_request``: Called after each
-  request is handled. Clean up / undo what was done in the prepare function.
-
-* ``cipher_one_request``/``hash_one_request``: Handle the current request by
-  performing the operation.
-
-Note that these functions access the crypto_async_request structure
-associated with the received request. You are able to retrieve the original
-request by using:
+Before transferring any request, you may provide additional callback
+functions within the ``struct engine`` instance you got from the alloc
+call:
 
-::
+* ``prepare_crypt_hardware``: Called once before any
+  ``do_one_request()`` invocations are done.
 
-	container_of(areq, struct yourrequesttype_request, base);
+* ``unprepare_crypt_hardware``: Called once after the
+  ``do_one_request()`` are done.
 
-When your driver receives a crypto_request, you must to transfer it to
-the crypto engine via one of:
+When your driver receives a crypto_request, and you want this request
+to be processed asynchronously, you must transfer it to the crypto
+engine via one of:
 
 * crypto_transfer_aead_request_to_engine()
 
-- 
2.43.0

