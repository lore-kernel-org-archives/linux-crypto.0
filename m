Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E7EC4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Jan 2023 07:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbjADHrF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Jan 2023 02:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbjADHqt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Jan 2023 02:46:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F5CE36
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 23:46:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CEEAB81203
        for <linux-crypto@vger.kernel.org>; Wed,  4 Jan 2023 07:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169F2C433D2;
        Wed,  4 Jan 2023 07:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672818406;
        bh=eZ4F0Vs4hiX60OmPCpMb00jhDPIHpJ7/GIt2QNFF9nQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BUXr8OEbEKq7c3348o7O/SgXTSn5m+j9xtbWZa059jYhiq/xl3AiGATLVCi77VRuO
         028FVZwEbHRimvUih8PW/BS+optm0pOUIp+Yipskim9+ssENT42AoLEiVY/5rQbl3t
         AuJ8L4z0s2AmeCnulYve/umAE37gbLd29NuwQGT3uxkrsMru6eRonAlLNVSVszdoia
         162a54dgdrYbAejmgoJLhycGUK5wFTOKDN9IWKfvn96vIhpdf3AWRLTzxQjjEkuILV
         AxhriNVud/4RAWCNdLZpNNR3qAGFG+9R3caQC33x4wt+ub0yRdJAAZ4W4ekd3F4pab
         GTZGjZ+wfxGng==
Date:   Tue, 3 Jan 2023 23:46:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: xor_blocks() assumptions
Message-ID: <Y7Uu5GkxfrejPJXL@sol.localdomain>
References: <Y7NizHFsWfMW/cC2@sol.localdomain>
 <CGME20230103111359eucas1p137cb823bdc80d790544de20c3835faf2@eucas1p1.samsung.com>
 <dleftjbknfoopx.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dleftjbknfoopx.fsf%l.stelmach@samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 03, 2023 at 12:13:30PM +0100, Lukasz Stelmach wrote:
> > It also would be worth considering just optimizing crypto_xor() by
> > unrolling the word-at-a-time loop to 4x or so.
> 
> If I understand correctly the generic 8regs and 32regs implementations
> in include/asm-generic/xor.h are what you mean. Using xor_blocks() in
> crypto_xor() could enable them for free on architectures lacking SIMD or
> vector instructions.

I actually meant exactly what I said -- unrolling the word-at-a-time loop in
crypto_xor().  Not using xor_blocks().  Something like this:

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 61b327206b557..c0b90f14cae18 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -167,7 +167,18 @@ static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
 		unsigned long *s = (unsigned long *)src;
 		unsigned long l;
 
-		while (size > 0) {
+		while (size >= 4 * sizeof(unsigned long)) {
+			l = get_unaligned(d) ^ get_unaligned(s++);
+			put_unaligned(l, d++);
+			l = get_unaligned(d) ^ get_unaligned(s++);
+			put_unaligned(l, d++);
+			l = get_unaligned(d) ^ get_unaligned(s++);
+			put_unaligned(l, d++);
+			l = get_unaligned(d) ^ get_unaligned(s++);
+			put_unaligned(l, d++);
+			size -= 4 * sizeof(unsigned long);
+		}
+		if (size > 0) {
 			l = get_unaligned(d) ^ get_unaligned(s++);
 			put_unaligned(l, d++);
 			size -= sizeof(unsigned long);

Actually, the compiler might unroll the loop automatically anyway, so even the
above change might not even be necessary.  The point is, I expect that a proper
scalar implementation will perform well for pretty much anything other than
large input sizes.

It's only large input sizes where xor_blocks() might be worth it, considering
the significant overhead of the indirect call in xor_blocks() as well as
entering an SIMD code section.  (Note that indirect calls are very expensive
these days, due to the speculative execution mitigations.)

Of course, the real question is what real-world scenario are you actually trying
to optimize for...

- Eric
