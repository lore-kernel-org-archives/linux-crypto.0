Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B291A42586B;
	Sat, 10 Oct 2026 07:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791617160; cv=none; b=jBbv04Zv61r2CXsD6THLzUW7TqIgiFIXuEr7QGjV1gll+ME0HTB+g7G77tFCqF0B1qglTCF5rg9y+s9nzCpvTtWf1qULdgHAD2YbWJDkB5PtWw+h/8f7UnO1RDgRokJSfHjUxJyXJi11OAkiFkzuJWTZC2CREAkI/ES/jK9sbMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791617160; c=relaxed/simple;
	bh=psSEhTAu6sd/btygb5O4mtgWqP0fyubjuaxPUt/yIxQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=tmd7rcH6pd8AI1hkEF/os5EfzKPuOKL97gW1ENZ3Dk06CEuXrieanVXhooIHTLIQxeOkjJQ4guzyfHn5amJSL4tBalsmwbqofq3fozoMppP7PWEPY8xXhu+5cXqGLmSN3KGXOnJNvVaVCPFkJ1iAPY4KVDmbc7bshKyrFKJiRNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=AyG5aA91; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="AyG5aA91"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1791617097;
	bh=f5XnlgkuyXmuZubmW1iV33/WbNbQKyGxmVA7ORE9aTQ=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=AyG5aA91QByma1CZsPYllkJe5iu+Yo13+hFuC/ag0VTmCPT9sJZ6axenJECheZj0n
	 oqTX9/jLBDw1sWi8xbfIL8otcoR/dEQ3RyESTlf0421GNnukXFM0eDdHN+9jyBOAvT
	 NW1vMdVx+TU5eaDGUPKjVnqAP5HvJdGv/UKNSUF8=
X-QQ-mid: zesmtpgz3t1791617081t38466de1
X-QQ-Originating-IP: gKWMmCO6Ux/ph6jGHs4xziZ9kQfZjAs/dywymu9EN04=
Received: from [10.10.7.69] ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 10 Oct 2026 15:24:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12070926784501131299
EX-QQ-RecipientCnt: 8
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Sat, 10 Oct 2026 15:23:58 +0800
Subject: [PATCH] crypto: hisilicon/sec - Fix double free of split
 scatterlists
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261010-hisilicon-sec-double-free-v1-1-05d6f9b901ae@uniontech.com>
X-B4-Tracking: v=1; b=H4sIAA3oyWoC/yXMUQrCQAyE4auUPBtIVqjFq4gPdju1kbIrG1uE0
 ru76uMHM/9GjmJwOjcbFazmllOFHhqK0y3dwTZUU5DQqqjwVCezxZzYEXnISz+DxwLwCZ100mo
 4qlD9PwtGe//al+vfvvQPxNc3SPv+AWH0bsB9AAAA
X-Change-ID: 20261010-hisilicon-sec-double-free-7e8080612310
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>, 
 John Garry <john.garry@linux.dev>, stable@vger.kernel.org, 
 ZhaoJinming <zhaojinming@uniontech.com>
X-Mailer: b4 0.15.2
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OHYeUdyRmGQYHA7oI7qlB4lkJz6f4mbVE8rwdYGA5Mu4cgArKPKFVAOd
	Fvc1S7M+8DX6lDG/4H5vN/6cCk3bGBtt0b/IrHn5aUmFDpbP2RLXtXsFxgv+oUL8YrCK6db
	4/mtoJZJo1UmemDw+den+qt1bEwR6M+kag9W0+syiz/LTRfdNF6cs2/K+lgOJywwZF5O4W7
	tLWfAU4jRZ4G7RDWnuF6CSUMY2zLNvnKFcw6wMQ+uGu26Wt2hrX9VVOdXN6Neq7pV3fCxYg
	+k4ubmTENq7rWIdQI3uKPB6fIPNf1322sUKL8ozR+QpdZZ8rBi6WZRnghJr+S9fde/MmRkv
	uT0c9QpPVAQRxt0qq0Uj55/YcpyGYzf6t7vLol7senDi0RPkMuYxh0UXSO3YxN96WP2MdtR
	/Ro/N/fgljxi45bS0gqhYtz7qaZeWdOdSC5HTjkHboZ3cWJ9qguJZCMeCDdA8g7cMMEO/3s
	ySvTZ44nA7y863+eUOpD4VpRWhxkOXloohNCkCJxvv0wjvSd64oxq9Fb2W0waYfgc9ezSFt
	nlumKJKz3Efr9qPYMOYNh8EFbA6e3497pv4652IilSuXtrCbH3qhmtaZjhVhxdNY8aDG/bG
	YwGgDd39Eddx52jdXmIYWdH7gE7Wa6dzDFSgEKvGCjMIljKgF5qlICFVmIv0TwhDQt69HYf
	vDCV4KmA+VweFInFVfbZYuSxW/L6SmgPTC1R0GL0TbO/ldfzt3uM3j1uav8/iR4u4I8l/wA
	lBVKEEE0jlivZsg6xHUYzzAU5Yvg7xDYoqRLY/Rl3ntzCVqBSmtynLps7n9szwuG/fzE3MZ
	DBir1hI22GUk7ETaJkcTQitxA1my+zcIfYCH/kbWJafB6wIPU1voBlhufiVfXj4A/jCMZv9
	WUfoUxiJhu+lGe6OVx/RjyAs7LDg0k31kyHnUqo6UsvsHmvGcD78VqH1JI79ARpfU3YGssd
	oWRGEqHu1MQoImlhmX31NNlLvNZB5cLzzfU9wTKm0/p7t6qEVUWmWoMzM+Yj432Jq67Nf/n
	q1Nmozz/o0q1T2/ueewmL/UYOQKEPVBzNNEkKihiWSEQvsiQYy2o8iUHaTeg8=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

sec_alg_skcipher_crypto() splits the request scatterlists into per-element
lists with sec_map_and_split_sg().  Each element keeps a reference to its
share in el->sgl_in/el->sgl_out, and sec_alg_free_el() releases them when
the element is torn down.

The error paths that jump to err_free_elements free the elements with
sec_alg_free_el(), which kfree()s el->sgl_in and el->sgl_out.  Execution
then falls through into err_unmap_out_sg/err_unmap_in_sg, where
sec_unmap_sg_on_err() kfree()s the very same splits[] pointers again, so
every scatterlist that was already attached to an element is freed twice.
This is reachable through the queue-full back-pressure path taken when the
request is not marked CRYPTO_TFM_REQ_MAY_BACKLOG, through a failed
sec_send_request(), or through a failed sec_alg_alloc_and_fill_el().

Hand ownership of the split scatterlists over to the element as soon as it
is created by clearing the matching entries in the splits_in/splits_out
arrays.  Entries that were never assigned to an element are still released
by sec_unmap_sg_on_err().

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
The per-element split scatterlists are released by sec_alg_free_el() and
then freed a second time by sec_unmap_sg_on_err() on the error path that
falls through from err_free_elements.  The bug has been present since the
driver was introduced in 915e4e8413da and was not covered by the earlier
error-path fix 0b0cf6af3f31, which only handled split_sizes and the
temporary pointer arrays.
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 85eecbb40e7e..fa9ccd8109f3 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -782,6 +782,15 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 			ret = PTR_ERR(el);
 			goto err_free_elements;
 		}
+		/*
+		 * The element owns the split scatterlists from here on and
+		 * releases them in sec_alg_free_el().  Drop the references
+		 * kept in the temporary pointer arrays so that the error
+		 * cleanup does not kfree() the same memory a second time.
+		 */
+		splits_in[i] = NULL;
+		if (split)
+			splits_out[i] = NULL;
 		el->req.cipher_iv_addr_lo = lower_32_bits(sec_req->dma_iv);
 		el->req.cipher_iv_addr_hi = upper_32_bits(sec_req->dma_iv);
 		el->sec_req = sec_req;

---
base-commit: 3857c2fe5449541e24afc5efdb0f81a8a8f9a3a0
change-id: 20261010-hisilicon-sec-double-free-7e8080612310

Best regards,
--  
ZhaoJinming <zhaojinming@uniontech.com>

