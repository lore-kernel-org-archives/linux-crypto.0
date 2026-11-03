Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692374;
	b=J3bjZvQbGENkUVGJzgFMblK6P8u/pnIi2+kkEFsYQwnswgbRebHErnPmt9mGEiWdcxGW
	 Lhqy9r7ypr5i8YglpVstLAS4XoWaWjpaFoDL6fv+nd6IDb2oEDe6vNGidTuXduG3MJzqC
	 V304k3dhBLZ2etYLPlTlfXyJmg2Lme1sH28iAfcOZpgGp4iesTR9gtC42aSkKGILHtc33
	 KiZM6H5BJQcs/j7+IJD6+jW+/MhhBXbieuS7j2E9ohvBye0ba0hKG0sDgi55Z0kErRL68
	 bpzrvjKpaIjcsda1TuW5kZQH86bvp07CXcarb5jkrTIL6wEwk5x+/i0TjqeGMk69DhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692374;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=kK+jdKNcJcWw9kFnkQjeWeFtjnujW3GF44sBiacgmG0=;
	b=QiIyjphFBGdtxr7sPIqS9CSJOlqr9EDd9lIKPYnooL2Xsb2sXUE7Uj7rvcCfw4iBsjyr
	 jq4j/GTuCY2kS+qNQm54PHFGQbfriuUkeuLZ6RP/L166m/App78a4AaBFsWwix6bSFl73
	 ayq4GWKCUGx/oQuxS2M3oGSVFhI3XrqS84YYdjNgAg7jHa27HHyUBj8bPCgzmdVq313d8
	 ybFuwXI2BsOgm0UuW/3DBpheKJoVy73H/Yduw+Vk6kGWoKL4AFaITaEHhvO4SO8RT7W4J
	 /p9ZYuXdSkWRVuEnGWYrWWMoJ27IZS+mCAIVvoPgliKMxgl267dBFLhRzzQEa75SdtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4287B606A324;
	Tue,  3 Nov 2026 07:52:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4287B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowACXaZrOkulqLBs6AA--.62913S2;
	Tue, 03 Nov 2026 15:52:46 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: ayush.sawal@chelsio.com,
	herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: chcr - Balance inflight count on invalid RFC4106 AAD length
Date: Tue,  3 Nov 2026 07:52:55 +0000
Message-Id: <20261103075255.1114171-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACXaZrOkulqLBs6AA--.62913S2
X-Coremail-Antispam: 1UD129KBjvJXoW7GF13Cry5XrykAr4ftFyDtrb_yoW8JF13pr
	Z0yFyFk3s8Jr1fGrn7tws5uFy3u39xZFWfKrs8tw40vwn8JFyxAw4v9a40vr1fJr1kGrZF
	vws7AF9xu3WDWaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VU1pnQU
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAQAA2rpWwrOjgAAsZ

chcr_aead_op() increments the device inflight counter before checking
the RFC4106 associated data length. If the length is invalid, it returns
-EINVAL without submitting a request or decrementing the counter. No
completion can balance that increment, so device teardown keeps seeing
an outstanding request.

Decrement the counter before returning from this validation failure,
matching the other synchronous error exits after chcr_inc_wrcount().

Fixes: d91a3159e8d9 ("Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/chelsio/chcr_algo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index fd4720fa50a9..ac4e40d5292c 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -3651,6 +3651,7 @@ static int chcr_aead_op(struct aead_request *req,
 	    crypto_ipsec_check_assoclen(req->assoclen) != 0) {
 		pr_err("RFC4106: Invalid value of assoclen %d\n",
 		       req->assoclen);
+		chcr_dec_wrcount(cdev);
 		return -EINVAL;
 	}
 
-- 
2.34.1

