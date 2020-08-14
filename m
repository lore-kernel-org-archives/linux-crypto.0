Return-Path: <SRS0=9//E=BY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6973CC433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Aug 2020 16:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F115720838
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Aug 2020 16:42:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="AlGsM3g9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgHNQmq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Aug 2020 12:42:46 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:8943 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgHNQmq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Aug 2020 12:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1597423361;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=8ljVb0A7kDBruZg7fCZlCgfDEHXd0ZwiOw8NsuhD7HY=;
        b=AlGsM3g9YhZGGTnCT8vKCcYtM1oSRUcXIyN/P+47pSLZAmIH7+U3Sy24GKV6ggswLM
        gPXBQw/clHpNdyJMlY7AV4wynTVPc6/4DDfOWNMlXdtt/hgQtgRiazU1mYZbFdHkxPg2
        YSpYETwII5vjFkWVujVJvcMfJ19MUGHv+rcB8fBlrXb/kQbrUvFj4WNyFY2Kjftb0GU0
        z8EjAOjZEXxKHwFTH8V7cpEkdjCPkohDGFP7oXJALT9nMpGYuFc7Ox/Hg2pTjpFxhw+a
        ctOvhi7ui2o5atIUxCwJVIS2hWiH8yCy+i4aNzv2mdfnGkLiiZF1DH2eEclECme5ykUM
        Dcpg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3IdRAZAL+p6A=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw7EGgdYFO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 14 Aug 2020 18:42:39 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Subject: Re: Information required on how to provide reseed input to DRBG
Date:   Fri, 14 Aug 2020 18:42:38 +0200
Message-ID: <4093118.6tgchFWduM@tauon.chronox.de>
In-Reply-To: <TU4PR8401MB12168D750EEF9AB43607FE8DF6430@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB1216EDF43D02A616A8022320F6430@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM> <24177500.6Emhk5qWAg@tauon.chronox.de> <TU4PR8401MB12168D750EEF9AB43607FE8DF6430@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 13. August 2020, 17:56:49 CEST schrieb Bhat, Jayalakshmi 
Manjunath:

Hi Jayalakshmi,

> Hi Stephen,
> 
> Thanks you very much on the response. I actually went through the code that
> you mentioned. My question is on inputting reseed. Example input I have is
> something like this
> 
> "entropyInput" :
> "F929692DF52BC06878F67A4DBC76471C03981B987FF09BF7E29C18AD6F7F8397", "nonce"
> : "8DB5A7ECEC06078C1C41D2C80AB6CB5EDFE00EA7B1AA6F4F907E80C9BAA008CE",
> "persoString" : "C99B39DD7B8FB0F772",
> "otherInput" :
> 	 {
> 		"intendedUse" : "reSeed",
> 	        	"additionalInput" : 
> "32ED729CD8FCC001B6B2703F0DBE04D5EED127A615212FEC967566ABBFBC8913027D ",
> "entropyInput" :
> "6FE46781AF69B38550A4D2C3888C8E515D28A2A4F141A041F3E2E9A753E46A30" },
> 	 {
> 		"intendedUse" : "generate",
> 		 "additionalInput" :
> "3C758EC9ECFD905E5865FD8343556815FBD8A064846252CBC161BFEAAC4FA9AF4D0DB8D8B9
> FD2E06B2C7A3FD55", "entropyInput" : ""
> 	},
> 	{
> 		"intendedUse" : "generate",
> 		"additionalInput" :
> "8F8F3F52D2CEF7FA788E984DA152ECA82CF0493E37985E387B3CFCEC2639F610431CA0A81F
> 740C4CD65230DD291733", "entropyInput" : ""
> 	}

Here is my code for that:


drbg_string_fill(&testentropy, entropyreseed->data,
				 entropyreseed->len);
drbg_string_fill(&addtl, addtlreseed->data, addtlreseed->len);
ret = crypto_drbg_reset_test(drng, &addtl, &test_data);

> 
> I understood
> how to use " entropyInput", " nonce" and " persoString".
> how to use " additionalInput" and " entropyInput" from generate section.
> My question is how to I use " additionalInput" and " entropyInput" from
> reSeed section.
> 
> I could see only below APIs available to set the values.
> crypto_drbg_get_bytes_addtl_test { crypto_rng_set_entropy,
> crypto_rng_generate) crypto_drbg_reset_test {crypto_rng_set_entropy,
> crypto_rng_reset}
> crypto_drbg_get_bytes_addtl { crypto_rng_generate)
> 
> I am not seeing any API to input reseed values or to trigger reseed?
> 
> Regards,
> Jaya
> 
> 
> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org
> <linux-crypto-owner@vger.kernel.org> On Behalf Of Stephan Mueller Sent:
> Thursday, August 13, 2020 8:48 PM
> To: linux-crypto@vger.kernel.org; Bhat, Jayalakshmi Manjunath
> <jayalakshmi.bhat@hp.com> Subject: Re: Information required on how to
> provide reseed input to DRBG
> 
> Am Donnerstag, 13. August 2020, 11:01:27 CEST schrieb Bhat, Jayalakshmi
> Manjunath:
> 
> Hi Jayalakshmi,
> 
> > Hi All,
> > 
> > I could successfully execute the CAVS test for DRBG with
> > ""predResistanceEnabled" : true" reseedImplemented": false.
> > 
> > I am trying to execute the tests with "predResistanceEnabled" : false;
> > "reseedImplemented" : true. But not successful.
> > 
> > Can anyone please let me know how to provide reseed data to DRBG?
> 
> See, for example, how drbg_nopr_sha256_tv_template is processed with
> drbg_cavs_test()
> 
> > Regards.
> > Jayalakshmi
> 
> Ciao
> Stephan


Ciao
Stephan


