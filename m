Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46478354AE3
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 16:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786119237; cv=none; b=BC1LSISiwdRyAp1eIGGwcJTe3nu74l/dZ8AxcDzP4wfEmT9HpiSpvbyqBh85uLayGch2t+YBAxjApFM2LSkDFuT0rAJJPOjzf4t3yWFR5Zz1AGHlf2KfLHlJEGlh4ZIFFSv+j5c8CuqoEz0eA2AnpFBobBbYxracbvHgYaLfGLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786119237; c=relaxed/simple;
	bh=t0Xer58sL6heqEqGaYvs7twJ2gJF7MKb+PJJ2R/T5uY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=clbaNxNcWVx1ZHre3kKzmUfbnQb2dxkAeJVjuVEsipFrJBaLnB8KkWXoiXDw3IgYRj3cyJgpgnHi4+ly7xrgo/QRqktnuJRNhwtXRoBuBc+PuUC6Uyi5b9wIEPoYUvi5cSWoEmesCDANh2AXzHUh08RI+hRjrI5Bvpur4HrX6IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=elixrAJh; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="elixrAJh"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c1f5208b38dso619793266b.0
        for <linux-crypto@vger.kernel.org>; Fri, 07 Aug 2026 09:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786119234; x=1786724034; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TPEYjqEYnl2DLLI5hMOioqJc22NNsDcohHqI88LFN80=;
        b=elixrAJhfFZBjQvB9BFwAYxZRZLB5oiQ+MqQzInJI6kiyT7wDYFHhIyizK5QqY7f/P
         pb44atvf2CfeEskoPbAUig+czm/hrpMrUBPkGOn7X3qSg4CnlgFNj4Ktes3bSko/JSm1
         OjclMrDyd5SEcTAflBQesBn6ESo2yYKn/oN/zn8yQB7DRuWP2tbsF78svY9eVuAukGdd
         +to5d0CmwyPJQiPujbFltSSjdv6l26vZVyqAOycB/mrnRUxbpTipjnX2IegfVYR4m3vy
         WRudRkIDTVevsSolMnc1JP/ra2zZV/eaTkhHt5LZQNvUEPDf2W3YI5m2G8LoQi4D+tgu
         ePfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786119234; x=1786724034;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TPEYjqEYnl2DLLI5hMOioqJc22NNsDcohHqI88LFN80=;
        b=pkZlwlcZBVXPpPHlbHRCfZimzSPDEnqIljbUzApu6J7EP3TvQYMfEcfxSVhB97nB8t
         x8hhlVZ/V7HtteBDYXupBYdnFzD/nV8zMb0VPjYQ5KXMe4LH1Z7o7k1hZNnq2mc4uwzO
         Bp3yyRLn0/2EQ3zhZOkSeAASOHBqqH1DlCyFRtLwcZ8MhGs2tUcdhPCyKkXqgmS1K6F4
         rRJ3hXIzoel7HnsouB+0jzeY7CnybJK1zkkKFjOW6nRSg/+ZRzmzXDOrWWA6LQXketUV
         vTX3R/UMCaCGAH8GPAI/edJ3+0lka9qTnd9bygRcud9O6sRUN3Jd64uwbVWJMOPzcz/q
         vG1A==
X-Forwarded-Encrypted: i=1; AHgh+RrsE5VeWISVdlF0c6Gx5WclDsyqA9e4g81hodiF7uvaatIiIxaxsPCVmtabREekdxAQdgcPBN8z/4/jYPk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwslkCao87BZLox3IzE0fpR5VusCazvwhDJt4oZAHx6eCKxJtMH
	IjVeEpx0H98uqdTCY4Sk/IGQj9eKkOYV61Evp7ntxCaHPDhmShHTGmUA
X-Gm-Gg: AR+sD13nsErqD/Jdk2aALcB4RKF8LvuCKO12aLPfhJazo1VKnzql+j8Lrt9Gqd036I8
	cbsJt3vQQZkgwdpJ2tgZsy10yZhjFRIcANbzWS0LPhIwsUgnZPs9Nh6cyoH/9o4LsKTE16kmszP
	G2JJpEu1rFzZAPqXFpHZ7xNdsWRJlmUdyVkxwie6HOPxTM32ZMHIk/lbrI1eFNYAjXoYubSCJj8
	Tal7UBhiW8t70gg5xD5ARQWlM1nsFPEEegbTiyHHYSDa9Gh90qwgdsJUkhwCGmLOAxhgsM4Fx8I
	6ZagGU8TMavQRW+MDtVeHIrFpDrQxsTcBGHlRS6HaOG3B53w7HQ3hYTcxFttAT7qsXP05tf3PHu
	hKv0Q+Nb050pPSyRDrMQOXMifGSl5HjQJt74oIEWsuPHI7U2XcWNkxpA6zb/HYKdJwNzpsQ/tid
	pnA3yGYAgvUbqr7YOOkJbp0gqXFLpGkotxNj+kGjZcQreysburI7cmvl3IVLxACGLqPTrks7OWa
	A1MwpV9p9Lz+YFtWqM=
X-Received: by 2002:a17:907:1ca7:b0:c1c:4adc:31a9 with SMTP id a640c23a62f3a-c2039e3fe56mr1214112566b.28.1786119234238;
        Fri, 07 Aug 2026 09:13:54 -0700 (PDT)
Received: from david.gall (k10193.upc-k.chello.nl. [62.108.10.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2080cf749fsm72440166b.58.2026.08.07.09.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:13:53 -0700 (PDT)
Date: Fri, 7 Aug 2026 18:13:52 +0200
From: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 1/2] crypto: keembay - use crypto_memneq() to compare GCM
 AEAD tags
Message-ID: <anYEQOzunX0Lm3N1@david.gall>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use crypto_memneq() for constant-time comparison.

The GCM path in keembay-ocs-aes-core.c verifes the received
authentication tag with memcmp(), which returns early on the first
mismatched byte. This leaks valid-prefix length and allows for valid
tag forgery which violates the INT-CTXT guarantee of AEAD.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
---
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 8a8f6c81e010..f8f4517ccad0 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -11,6 +11,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/utils.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/dma-mapping.h>
@@ -919,7 +920,7 @@ static int kmb_ocs_aead_run(struct aead_request *req)
 
 	/* For GCM decrypt, we have to compare in_tag with out_tag. */
 	if (rctx->instruction == OCS_DECRYPT) {
-		rc = memcmp(rctx->in_tag, rctx->out_tag, tag_size) ?
+		rc = crypto_memneq(rctx->in_tag, rctx->out_tag, tag_size) ?
 		     -EBADMSG : 0;
 		goto exit;
 	}
-- 
2.43.0

