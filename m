Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F341E47B3;
	Tue,  1 Apr 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743519058; cv=none; b=K9tdvWMXrtqI21ZNkA2FkoItDCNysM1B78yg0T3EVPbHixKxVtgg4nNC9H59kWRpZs/gZ/ZUCKrVcHxSX8D6//i1F0/2J30VHQwF33v1k7FZoZtMXxl6Pqmm5IXHVxFA9TKy3fwANrkydMiWxAlbfwrf2VSC2qKYn1dAZyW6Osk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743519058; c=relaxed/simple;
	bh=Mv/7zMBiwb5gAMPkPyBbHEzvG1xCA85ECVJWhXZm6uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgpxqpxdpvO38guI2ANKVy7EovY7GYx9vob5NuPLsLX900ca32dRDsdC77zVx0LiiI0lU5j5idu0PQuCeQONv4+qV68DRqulSEVGxzKvbUpc1hzQJJwXpYhEHSViqcwLBti1xxniHj2GAomdLuOUoBFFAOdw9iATMQchbWgaArE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=COEXob/o; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="COEXob/o"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5318bXQw011292;
	Tue, 1 Apr 2025 14:50:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1rYnEf9GN9FWsJos4
	3c2Xr4krI+XIdkOBGcoTSPTg34=; b=COEXob/olbCZ0RUrv2g2XmRqMtsfcP+Hz
	5NGgTtVxobOO6wp3VawvVybgvKcUJoHR2gyy7fFjFB8bgpUgAWj2AKMVNdKUE+R7
	UqkuKMSK7+dXBKKfI7CwjXJQwu8TuqpBuvPs6NWdKWWVM4oQLsGOCC4k2pD4js/8
	9lz7T5SECNBE9nMNyWA+vpukDIa15iXcof4MEpj1YUmVG8vtKXuiFeg0tHP+3iEg
	Wv6voV5ybWdJLc7xEnGAbsqFPQcNPdOJWMx0QJERE5JFvi+9gRULlMKMNg519ZKm
	CZzzR9AwpJ9XW2rWxdya7bIVoRqaz61Mu9Y9VsxIKZVP1Z+sGGxkQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45r290maxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Apr 2025 14:50:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 531BbanW019413;
	Tue, 1 Apr 2025 14:50:52 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45pu6t37fd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Apr 2025 14:50:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 531EonFe32965076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Apr 2025 14:50:49 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 540EF20040;
	Tue,  1 Apr 2025 14:50:49 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A50A2004D;
	Tue,  1 Apr 2025 14:50:49 +0000 (GMT)
Received: from funtu2.boeblingen.de.ibm.com (unknown [9.152.224.229])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  1 Apr 2025 14:50:49 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com,
        fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 3/3] Documentation: crypto_engine: Update and extend crypto engine doc
Date: Tue,  1 Apr 2025 16:50:48 +0200
Message-ID: <20250401145048.52564-4-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250401145048.52564-1-freude@linux.ibm.com>
References: <20250401145048.52564-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: otUhCinEq66YU-J-dmO_DyWWzSw-KRsP
X-Proofpoint-GUID: otUhCinEq66YU-J-dmO_DyWWzSw-KRsP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-01_05,2025-04-01_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502280000 definitions=main-2504010090

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

