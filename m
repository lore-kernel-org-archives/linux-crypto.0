Return-Path: <SRS0=Rknj=QD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAAA8C282C0
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9D70214C6
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:17:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="IeNdexJ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfA0JRT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jan 2019 04:17:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36510 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfA0JRT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jan 2019 04:17:19 -0500
Received: by mail-wr1-f68.google.com with SMTP id u4so14621017wrp.3
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jan 2019 01:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UT69eWfMu3CrrEpHcC7N6bP4fh+2YTgZE2AB6r62TDY=;
        b=IeNdexJ3bUTrMk4sXS7K0+u+EMGHsicTnWcivNUNYMsBQyC5yPbx7ngfpvEX2DOMZS
         2bDszTF0BfN1i1/BqJsbs3UGJQSZj6BaOSE4ijRtoAg7gAg63BfZv914388GDT0JiBGW
         KMe8WOutx6M+EPjiD6sQusFPgxEA1D8LHLxxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UT69eWfMu3CrrEpHcC7N6bP4fh+2YTgZE2AB6r62TDY=;
        b=NE0kvc6DpqXAsstYIIX7cgb9EYaaPzIjw0gmoUPMvQUXlFvS2R+OqbFnVYSuGhi65h
         a8d4ccx1doL8GdmUjV3h5lkaBKEIVvW/xZJczis36onl6Afc4bLCLSo1Hvl9Oml12P06
         /WzoNhbIiTlHWVqbsjbR1G2D9BskZ28gS8FO3/Z7OgaFf9hpYF7/VAEppWqKbnE06ih4
         idwsY8yFB7oteHHOjvAT9OAUGSQRmdoZbraEPhqJ8kohS+sUWu9w7w5cn12ye+4YHoAJ
         fRxnk7CUgMAfq+TxANMS6s4txUMhViiynRmW9y+RA3WeLl4tnsI0veioM4QLixMxRk9b
         CXUQ==
X-Gm-Message-State: AJcUukenrYq0dUq9wvlu7O3PUesg0LCi+di/JdR5XRqad6nm3RMiLS0A
        dxq4dkg8RXtFRkGsKrRD4YX0eUkEsqFDYA==
X-Google-Smtp-Source: ALg8bN5FEPWbExVQhAyDBodyH+yZuBLXAdLgtHl+4Aby8lYZbL8PAmxOPHSIf3+vobLpq56MsM3kKg==
X-Received: by 2002:a5d:664a:: with SMTP id f10mr17358060wrw.311.1548580637102;
        Sun, 27 Jan 2019 01:17:17 -0800 (PST)
Received: from sudo.home ([2a01:cb1d:112:6f00:887d:32e9:9391:d3bf])
        by smtp.gmail.com with ESMTPSA id o5sm45397013wrw.46.2019.01.27.01.17.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 01:17:16 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 3/4] crypto: arm/crct10dif - remove dead code
Date:   Sun, 27 Jan 2019 10:16:54 +0100
Message-Id: <20190127091655.6262-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
References: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove some code that is no longer called now that we make sure never
to invoke the SIMD routine with less that 16 bytes of input.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/crct10dif-ce-core.S | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
index 16019b5961e7..d058fad423c2 100644
--- a/arch/arm/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -342,7 +342,6 @@ CPU_LE(	vrev64.8	q7, q7		)
 
 	cmp		arg3, #16
 	beq		_128_done		// exactly 16 left
-	blt		_less_than_16_left
 
 	// now if there is, load the constants
 	vldr		d20, rk1
@@ -353,18 +352,6 @@ CPU_LE(	vrev64.8	q7, q7		)
 	addlt		arg3, arg3, #16
 	blt		_get_last_two_regs
 	b		_16B_reduction_loop
-
-_less_than_16_left:
-	// shl r9, 4
-	adr		ip, tbl_shf_table + 16
-	sub		ip, ip, arg3
-	vld1.8		{q0}, [ip]
-	vmov.i8		q9, #0x80
-	veor.8		q0, q0, q9
-	vtbl.8		d18, {d14-d15}, d0
-	vtbl.8		d15, {d14-d15}, d1
-	vmov		d14, d18
-	b		_128_done
 ENDPROC(crc_t10dif_pmull)
 
 // precomputed constants
-- 
2.20.1

