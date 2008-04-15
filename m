From: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [2.6 patch] add include/asm-avr32/xor.h
Date: Mon, 14 Apr 2008 20:47:03 -0400
Message-ID: <8bd0f97a0804141747q482c808aiac03713a6afa0adf@mail.gmail.com>
References: <20080414141632.GA6695@cs181133002.pp.htv.fi>
	 <20080414181140.GA813@Chamillionaire.breakpoint.cc>
	 <20080414181536.GZ6695@cs181133002.pp.htv.fi>
	 <20080414214640.GA2282@Chamillionaire.breakpoint.cc>
	 <20080414220129.GH26885@cs181133002.pp.htv.fi>
	 <8bd0f97a0804141511o28385fcfl11923148f7fe701a@mail.gmail.com>
	 <e9c3a7c20804141527k475ee297wdf1053179abdaaf8@mail.gmail.com>
	 <8bd0f97a0804141530i7c6ee03codeb0a546d333cb2f@mail.gmail.com>
	 <e9c3a7c20804141645k6bdb075ax25e57f41e45e5105@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Adrian Bunk" <bunk@kernel.org>,
	"Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>,
	hskinnemoen@atmel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, shannon.nelson@intel.com
To: "Dan Williams" <dan.j.williams@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:11503 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbYDOArD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Apr 2008 20:47:03 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1741606wff.4
        for <linux-crypto@vger.kernel.org>; Mon, 14 Apr 2008 17:47:03 -0700 (PDT)
In-Reply-To: <e9c3a7c20804141645k6bdb075ax25e57f41e45e5105@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 14, 2008 at 7:45 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Apr 14, 2008 at 3:30 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>  > On Mon, Apr 14, 2008 at 6:27 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> >  >  "arches" did not have to go through and figure out the fun little stub
>  >  >  file for xor.h.  Adrian already made your "life easier".
>  >
>  >  actually he didnt.  he posted a fix for avr32.  i dont care about
>  >  avr32, i'm a blackfin guy.  he also wouldnt have had to do anything at
>  >  all if everything was handled with indirection in linux/xor.h.
>  >
>  >  your point also is irrelevant in the case of new architectures.  poor
>  >  microblaze for example.
>
>  Don't get me wrong I see the pain-reducing-value in codifying all the
>  features that have architecture specific aspects with HAVE_* config
>  variables.  But in this case I think a 6 line patch per new arch gets
>  the immediate job done.

sure ... i see the original patch as OK to get things working now
(especially as that is how the xor stuff is currently architected).
bigger picture is to go the common route proposed by Sebastian.  now
just need to sucker someone into doing the footwork :).
-mike
