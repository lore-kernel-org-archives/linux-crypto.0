Return-Path: <SRS0=zaW3=BX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6310BC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 15:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEF7F20829
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 15:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="QFlRRlE0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgHMPRk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:17:40 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:21033 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMPRj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Aug 2020 11:17:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1597331854;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=j5tofF5LIsC+jH8q/8U+lPU6bUDRkPO/eHxPSgMWCMc=;
        b=QFlRRlE0fte6ROrKUeX93SDHh3jhJLYw+i8qy8zZT4QSsc7WtWfx8200F3M27yWghA
        iZtf/15jYGMEqTrsFeCSqY59pdL7sivQbrmecAdG8Ze1M8c73XywPLtpyDJpSUOg2r5f
        54cUpmDLiUlcPYSqDSi3H8BqT3gjcbeB/1w4nXdd4BOp5rPwElCtZnPi4tfmn9PI0E1u
        J0JHSaP4wru/+2fW1ZsRKh1kInLAh2mpwWgp1hzOGWkhvjl+k4oc3b50JfdGxMyf8NAC
        ZURwSBkjyfy5bXTZgnJRX/KS1pXFKliUBbBaicvEZ1gfmVytSIKvs9GllMNQE2vuQRUY
        h2DQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3IdRAZAL+p6A=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw7DFHWSqj
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 13 Aug 2020 17:17:32 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Subject: Re: Information required on how to provide reseed input to DRBG
Date:   Thu, 13 Aug 2020 17:17:31 +0200
Message-ID: <24177500.6Emhk5qWAg@tauon.chronox.de>
In-Reply-To: <TU4PR8401MB1216EDF43D02A616A8022320F6430@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB1216EDF43D02A616A8022320F6430@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 13. August 2020, 11:01:27 CEST schrieb Bhat, Jayalakshmi 
Manjunath:

Hi Jayalakshmi,

> Hi All,
> 
> I could successfully execute the CAVS test for DRBG with 
> ""predResistanceEnabled" : true" reseedImplemented": false.
> 
> I am trying to execute the tests with "predResistanceEnabled" : false;
> "reseedImplemented" : true. But not successful.
> 
> Can anyone please let me know how to provide reseed data to DRBG?

See, for example, how drbg_nopr_sha256_tv_template is processed with 
drbg_cavs_test()
> 
> Regards.
> Jayalakshmi


Ciao
Stephan


