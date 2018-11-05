Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF82EC0044C
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Nov 2018 18:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C702220862
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Nov 2018 18:23:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C702220862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbeKFDoN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Nov 2018 22:44:13 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:55708 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729559AbeKFDoN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 22:44:13 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id D0FC672CC68;
        Mon,  5 Nov 2018 21:23:15 +0300 (MSK)
Received: from sole.flsd.net (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id B81624A4A29;
        Mon,  5 Nov 2018 21:23:15 +0300 (MSK)
Date:   Mon, 5 Nov 2018 21:23:14 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] crypto: streebog - add Streebog hash function
Message-ID: <20181105182314.c7xdsolvxr2iyd5n@sole.flsd.net>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20181024032356.3388-1-vt@altlinux.org>
 <20181024032356.3388-2-vt@altlinux.org>
 <CAKv+Gu9LSUNwW_3E3QtxV123u=mU-B+p6FFRAkWq8_e9Jsgb2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9LSUNwW_3E3QtxV123u=mU-B+p6FFRAkWq8_e9Jsgb2w@mail.gmail.com>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181105182314.O9_3BDR2YY7AjarEvPyFUIV46FQ92oqdFRh2BiGJkWc@z>

Ard,

On Mon, Nov 05, 2018 at 02:22:21PM +0100, Ard Biesheuvel wrote:
> 
> > +static const struct streebog_uint512 buffer512 = { {
> > +       cpu_to_le64(0x200ULL),
> 
> Can we keep the memory representation in native endianness, and only
> swab the in/output [where needed]?

I hope you do not insist on that?

The code is using same primitives to add/xor/permute with data from
these arrays (buffer512[] and C[], those which use cpu_to_le64), and
from generic data buffers. Having these arrays in native endianness will
cause complexities - code split and duplications. For example, XLPS
permutation will require two versions, with one accessing (y) as is and
another as cpu_to_le64(y).

The code is based on canonical implementation by RFC 6986 ("GOST R
34.11-2012: Hash Function") author, and I don't want it do deviate that
much from the original, which would complicate algorithm reviews.

Thanks,

