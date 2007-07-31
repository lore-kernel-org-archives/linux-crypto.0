From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
Subject: Re: Crypto API Weirdnesses
Date: Tue, 31 Jul 2007 09:32:08 -0400
Message-ID: <31e679430707310632u52f43fefg8313143953ccb9b3@mail.gmail.com>
References: <31e679430707301336v37bc7433jed09451ab60ad89a@mail.gmail.com>
	 <alpine.LFD.0.999.0707311837470.26032@enigma.security.iitk.ac.in>
	 <961aa3350707310626l24d1d910u75ed703d8d422082@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Satyam Sharma" <satyam@infradead.org>,
	linux-kernel@vger.kernel.org,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, dm-devel@redhat.com
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:64017 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260AbXGaNcJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Jul 2007 09:32:09 -0400
Received: by rv-out-0910.google.com with SMTP id k20so595938rvb
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jul 2007 06:32:09 -0700 (PDT)
In-Reply-To: <961aa3350707310626l24d1d910u75ed703d8d422082@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/31/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > > "Failed to setup dm-crypt key mapping.
> > > Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and
> > > verify that /dev/hda4 contains at least 133 sectors.
> > > Failed to read from key storage"
> >
> > Looks like a "cryptsetup" error message, not kernel's.
>
> I can't find CONFIG_DM_CRYPT in the .config.
> Maybe cryptsetup needs it.

yeah... it was that... working ;-)

btw... why DM_CRYPT is below "Multi-Devices" menu and not in
"Cryptographic Options"?



>
> We should improve cryptsetup error message.
>


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
