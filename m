From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
Subject: Re: Crypto API Weirdnesses
Date: Tue, 31 Jul 2007 09:43:10 -0400
Message-ID: <31e679430707310643h670ffb1bg852f0e14eafa11a9@mail.gmail.com>
References: <31e679430707301336v37bc7433jed09451ab60ad89a@mail.gmail.com>
	 <alpine.LFD.0.999.0707311837470.26032@enigma.security.iitk.ac.in>
	 <961aa3350707310626l24d1d910u75ed703d8d422082@mail.gmail.com>
	 <31e679430707310632u52f43fefg8313143953ccb9b3@mail.gmail.com>
	 <alpine.LFD.0.999.0707311916150.26032@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Akinobu Mita" <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, dm-devel@redhat.com
To: "Satyam Sharma" <satyam@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:15952 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXGaNnK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Jul 2007 09:43:10 -0400
Received: by rv-out-0910.google.com with SMTP id k20so598273rvb
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jul 2007 06:43:10 -0700 (PDT)
In-Reply-To: <alpine.LFD.0.999.0707311916150.26032@enigma.security.iitk.ac.in>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/31/07, Satyam Sharma <satyam@infradead.org> wrote:
> Hi,
>
>
> On Tue, 31 Jul 2007, Felipe Balbi wrote:
>
> > On 7/31/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > > > > "Failed to setup dm-crypt key mapping.
> > > > > Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and
> > > > > verify that /dev/hda4 contains at least 133 sectors.
> > > > > Failed to read from key storage"
> > > >
> > > > Looks like a "cryptsetup" error message, not kernel's.
> > >
> > > I can't find CONFIG_DM_CRYPT in the .config.
> > > Maybe cryptsetup needs it.
> >
> > yeah... it was that... working ;-)
>
> Ugh, you should at least be checking if you've built the kernel with the
> same config options :-) Of course, if you did a simple "make oldconfig"
> but still lost some config options, then that's definitely a regression...
> (was that the case here, btw?)

yeah... I was make oldconfig'ing :-p

>
>
> > btw... why DM_CRYPT is below "Multi-Devices" menu and not in
> > "Cryptographic Options"?
>
> Well, DM_CRYPT /is/ a device-mapper target first. "Cryptographic options"
> is for _actual_ crypto code, such as algorithm implementations etc. Users
> such as encrypting file systems / IPsec / dm-crypt are better off at their
> logical places, I'd say.

Hmmm... ok... thanks for the clarification ;-)

>
>
> Satyam
>


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
