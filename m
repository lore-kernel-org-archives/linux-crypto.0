Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B88A54EEC4
	for <linux-crypto@vger.kernel.org>; Tue,  8 Sep 2026 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788878116; cv=none; b=NOYYp59eMRtY3Z16TDLcoWzZDOS4zDWdIs7l517rmJXfPl9DolzEXuKHbFdPPsijj7uncFk01AfbGOW4vIIC5g69obJU6wq8w9BDkOsG1mYSZMFYwVXk5AvmlpJL1Odm9Sem/lmVfLI+/wiN1JQS4g3ytng+23ta1BMX7He63RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788878116; c=relaxed/simple;
	bh=BfLF/Aj5a2l/eiHeKL8scRNQ5iV8q4zXfLB9x+4z/8I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CegHq3Vq4pEiPrbwzMBIUx9UQMk1xGKCBw7vifcsNNRqIZWSz0gDSwXMCKPMs5P5Cjw2tgXbBSTSKUhjwseWL3jWo+vp2c/qaLh0hEveWlIaow1JThvSKm2PDz/zt8iPipauGWcIQSHuj/hWdQnFqmKcxMUnE1SVc2KuNp1jGsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tCYe4Bvp; arc=none smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tCYe4Bvp"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b1a4fcso341323e87.2
        for <linux-crypto@vger.kernel.org>; Tue, 08 Sep 2026 07:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788878104; x=1789482904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MW4LrkosLq6x3pWpb8ZQTriCBVYq7W5XekYvYQdHPT0=;
        b=tCYe4BvpdSfzdybPtfB68UUi9LwOUXrcCYcyVxdcJuQYmt6d0Z5VW16P6jSPdNlOGw
         uKLeMilJBhY4T2cnadX9RDtcCEYZZQ38q7/8N2NDVeqeyHa24dI+BmAVypnACc2TnwZK
         WrCxNihbsHZmDYKPvZbmCfECod96Z8cXKgnYdDNi5mKTlgnhP8HHpXBY9Lq2ITIov0Zl
         1CBfybWFAIHQeYBZHruZk5MUERhOoJ4J8IDvQ7oDAq/B/ajXVYJe0y/IvReV7qp1wSyi
         eknEQHgLBGoXDXk4I8LIm3qfNBu/nWCjT1tuKCyWCLHniuH+5NCxEiEndTwWssRoDxjb
         OvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788878104; x=1789482904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MW4LrkosLq6x3pWpb8ZQTriCBVYq7W5XekYvYQdHPT0=;
        b=PqzPowb8NmgmZj3YOhqvgiv8lwQs9xzXHpw+MqQloswR8TArzL3thaolySG8u0fpK+
         jt3/DDHL6jAN4LuQR/2gYgSIaduqW6AKAepDQeC0A16K5RzZSWZkBr21FI9LWHPklhz9
         3YNNgo7K86DMokCaM86vdrR9F/yVlpX0iSmj9zSzbnIvvUTOgAPRAQqtAOKIL1pif2yV
         ylQYxggt/LAqATSNFKkfJ3stIhLCz31Tfii87rr4zfsXIpoauCD/LMlIFaSZ2cruHf65
         K+gGNq4WmNPvJ6DlDU8GcLqaZB9XBbly7Z5sEkPJVHsiBCZNaGYmHLRIxDj2VFHJ7MIg
         3AhA==
X-Forwarded-Encrypted: i=1; AKwUvBxl+osmWZCtR28AmP+rofqmMvupWhtMrkmsw+T1n+EIZ5Jqn3amGZ0mESzApmktWUXx3TNZTN7UH+Bt+z8=@vger.kernel.org
X-Gm-Message-State: AFuF++kdEmjbBf/f3HjK6NJclYDB6NSPhd9gD00idic68N16AFAW43CM
	TwgKnKjxEShmM7cd+AT7Svn0kdPXx2gzPNWdH1ZSLZFO4WrFTWOupoZL
X-Gm-Gg: AYBFou22gS+o71o4cclbgRqcdazLPdFfN6zCfEtZe/C5TCYPDysWLaedpY9AK57jgQA
	l23/+hufeh+Ckzf8CgqCBfcRu1AoaknDVowiTa5D8sS+2XFYPEoaaYMcCtd3QJ7+vEuZnWiYNN3
	nS+JtaqhXvc3tlvSVGKR7pVk98c+otek+ndClrIS5jITet+qQoxqIMzUm+jmkWHt+5/TScCxl2Y
	FXiYZNBfSoOMvJEUbyE8dvlUjCg0gVGGbMsalYkzUzjcuuYRX0R1uvmSwKZ0qYQFaTu3GmHTmWX
	V1lF6QONGFYnvF4mSrMnoBaAPlSNu0H98e30k097ju2vJnq7Shj48ucSXHNVp/u+hLlLwS8JCUa
	YwYu3lHFM3SnaFpcsrEDv5ZdQiaKQoEYc8BOEyebk3LDB2CpZvtV832SmgAn3nvPH3e2C3PdPJq
	6WQMtCUUu0uetFrfWLCQXzI2JmbV42uN7IdR6ioiE+Uz59sjpN7p440n9vH8pO6cDdCp24Cb7uw
	Dg=
X-Received: by 2002:a05:6512:685:b0:5ae:b2df:c11a with SMTP id 2adb3069b0e04-5b74d4055d3mr4095036e87.0.1788878103832;
        Tue, 08 Sep 2026 07:35:03 -0700 (PDT)
Received: from localhost.localdomain ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b616709f95sm3092257e87.74.2026.09.08.07.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 07:35:02 -0700 (PDT)
From: Dmitriy Okunev <dokunevdmitriy@gmail.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	lvc-project@linuxtesting.org,
	Declan Murphy <declan.murphy@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Mark Gross <mgross@linux.intel.com>,
	Daniele Alessandrelli <daniele.alessandrelli@gmail.com>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: keembay-ocs: prevent underflow in sg_data_total - remainder
Date: Tue,  8 Sep 2026 17:34:47 +0300
Message-ID: <20260908143447.2155188-1-dokunevdmitriy@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the kmb_ocs_dma_prepare() function, the `remainder` is calculated
as `total % blk_sz`, where `total = sg_data_total + buf_cnt`. In
update requests, if `buf_cnt` is large and `total` is less than
`rctx->blk_sz`, the `remainder` may exceed `sg_data_total`, which
will lead to an overflow of `sg_data_total - remainder`. This results
in an incorrect large value being passed to the `sg_nents_for_len()`
function, which can lead to memory corruption.

Add a check to return -EINVAL if `sg_data_total < remainder`,
so that the subtraction is always safe.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
Signed-off-by: Dmitriy Okunev <dokunevdmitriy@gmail.com>
---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index 9a67bb4ecc82..92f2d9ff6f83 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -246,8 +246,11 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 	 * HCU must be aligned to the block size; compute the remainder data to
 	 * be processed in the next request.
 	 */
-	if (!(rctx->flags & REQ_FINAL))
+	if (!(rctx->flags & REQ_FINAL)) {
 		remainder = total % rctx->blk_sz;
+		if (rctx->sg_data_total < remainder)
+			return -EINVAL;
+	}
 
 	/* Determine the number of scatter gather list entries to process. */
 	nents = sg_nents_for_len(req->src, rctx->sg_data_total - remainder);
-- 
2.53.0

