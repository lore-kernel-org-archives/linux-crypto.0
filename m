From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Wed, 2 Mar 2016 08:03:44 -0500
Message-ID: <CACXcFmmuBJR93nW+-Qp2Yo95EXzuz+RXyH9_hw+RVXFqYZtgrw@mail.gmail.com>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
	<2214574.VuIVa0pDBJ@positron.chronox.de>
	<20160301110834.GA2383@sbenedet-virtual-machine>
	<4569151.ySIvlNFRgX@positron.chronox.de>
	<20160302095351.GB2384@sbenedet-virtual-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35659 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbcCBNDp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Mar 2016 08:03:45 -0500
Received: by mail-io0-f170.google.com with SMTP id g203so258173383iof.2
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2016 05:03:44 -0800 (PST)
In-Reply-To: <20160302095351.GB2384@sbenedet-virtual-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Salvatore Benedetto <salvatore.benedetto@intel.com> wrote:

>> > > > +static int dh_check_params_length(unsigned int p_len)
>> > > > +{
>> > > > +       switch (p_len) {
>> > > > +       case 768:
>> > > > +       case 1024:
>> > > > +       case 1536:
>> > > > +       case 2048:
>> > > > +       case 3072:
>> > > > +       case 4096:
>> > > > +               return 0;
>> > > > +       }
>> > > > +       return -EINVAL;
>> > > > +}
As far back as 1999, the FreeS/WAN project refused to
implement the 768-bit IPsec group 1 (even though it was
the only one required by the RFCs) because it was not thought
secure enough. I think the most-used group was 1536-bit
group 5; it wasn't in the original RFCs but nearly everyone
implemented it.

>> And besides, I would like to disallow all < 2048 right from the start.

I'm not up-to-date on the performance of attacks. You may be right,
or perhaps the minimum should be even higher. Certainly there is
no reason to support 768 or 1024-bit groups.

On the other hand, we should consider keeping the 1536-bit
group since it is very widely used, likely including by people
we'll want to interoperate with.

> Hmm.. What range would you suggest?

There are at least two RFCs which define additional groups.
Why not just add some or all of those?
https://tools.ietf.org/html/rfc3526
https://tools.ietf.org/html/rfc5114
