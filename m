From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [2.6 patch] add include/asm-avr32/xor.h
Date: Mon, 14 Apr 2008 15:27:45 -0700
Message-ID: <e9c3a7c20804141527k475ee297wdf1053179abdaaf8@mail.gmail.com>
References: <20080414141632.GA6695@cs181133002.pp.htv.fi>
	 <20080414181140.GA813@Chamillionaire.breakpoint.cc>
	 <20080414181536.GZ6695@cs181133002.pp.htv.fi>
	 <20080414214640.GA2282@Chamillionaire.breakpoint.cc>
	 <20080414220129.GH26885@cs181133002.pp.htv.fi>
	 <8bd0f97a0804141511o28385fcfl11923148f7fe701a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Adrian Bunk" <bunk@kernel.org>,
	"Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>,
	hskinnemoen@atmel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, shannon.nelson@intel.com
To: "Mike Frysinger" <vapier.adi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:18069 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYDNW2I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Apr 2008 18:28:08 -0400
Received: by yw-out-2324.google.com with SMTP id 5so819478ywb.1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Apr 2008 15:27:45 -0700 (PDT)
In-Reply-To: <8bd0f97a0804141511o28385fcfl11923148f7fe701a@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 14, 2008 at 3:11 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, Apr 14, 2008 at 6:01 PM, Adrian Bunk <bunk@kernel.org> wrote:
>  > On Mon, Apr 14, 2008 at 11:46:40PM +0200, Sebastian Siewior wrote:
>
> >  > so most
>  >  > xor.h files are identical copies and this is probably as bad as a
>  >  > trailing white space :)
>  >
>  >  I'm not sure whether it's worth spending my time discussing whether
>  >  adding a config variable to 6 architectures is really better than
>  >  adding trivial headers to 3 architectures...
>
>  long term robustness for new ports/codedrops indicates that having a
>  common header in linux/ and making arches opt-in via Kconfig/whatever
>  makes life a lot easier for everyone
>
>  everything builds by default with the generic C versions and arches
>  dont have to go through and figure out all the fun little stub files
>  they need to straight copy from other architectures ... they only have
>  to care if they want to implement an optimized version

"arches" did not have to go through and figure out the fun little stub
file for xor.h.  Adrian already made your "life easier".

--
Dan
