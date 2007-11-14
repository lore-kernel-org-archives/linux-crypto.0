From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Wed, 14 Nov 2007 00:38:31 -0700
Message-ID: <200711140038.31859.vda.linux@googlemail.com>
References: <200711131947.09040.vda.linux@googlemail.com> <200711132230.47844.vda.linux@googlemail.com> <20071113.221041.47706914.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: takamiya@po.ntts.co.jp, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:4696 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbXKNHil (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Nov 2007 02:38:41 -0500
Received: by wa-out-1112.google.com with SMTP id v27so99647wah
        for <linux-crypto@vger.kernel.org>; Tue, 13 Nov 2007 23:38:41 -0800 (PST)
In-Reply-To: <20071113.221041.47706914.davem@davemloft.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday 13 November 2007 23:10, David Miller wrote:
> From: Denys Vlasenko <vda.linux@googlemail.com>
> Date: Tue, 13 Nov 2007 22:30:47 -0700
>
> > On Tuesday 13 November 2007 20:49, David Miller wrote:
> > > From: Denys Vlasenko <vda.linux@googlemail.com>
> > > Date: Tue, 13 Nov 2007 19:47:08 -0700
> > >
> > > > If CONFIG_CC_OPTIMIZE_FOR_SIZE is not an acceptable method,
> > > > do you have other ideas?
> > >
> > > Look at ways to make the code run faster without loop unrolling?
> >
> > I did it. I noticed that key setup is mostly operating on 64-bit
> > quantities, and provided alternative implementation which
> > exploits that fact. It's smaller and faster.
>
> Great, then you don't have to unroll the loop and performance
> is at least as good as before _and_ you save code space.

Unfortunately, it's applicable only to key setup,
and unrolling happens in actual encryption.

But the point still stands: irrespective of other optimizations,
unrolled and non-unrolled forms will still have different sizes
and speeds, and in some cases (like this one) you can't
pick one form which fits all.

> Please submit this new version :-)

Just did it. It's linux-2.6.23.1.camellia5.diff
--
vda
