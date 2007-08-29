From: David McCullough <David_Mccullough@securecomputing.com>
Subject: Re: OCF(20070727) cryptosoft errors with openssl 0.9.8e
Date: Thu, 30 Aug 2007 09:10:34 +1000
Message-ID: <20070829231034.GA5844@securecomputing.com>
References: <20070829125325.GB30139@securecomputing.com> <913426.96574.qm@web62509.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ocf-linux-users@lists.sourceforge.net
To: Eran Ben-Avi <eranpublic@yahoo.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:39106 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755639AbXH2XFi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 19:05:38 -0400
Content-Disposition: inline
In-Reply-To: <913426.96574.qm@web62509.mail.re1.yahoo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Jivin Eran Ben-Avi lays it down ...
> Hi,
> 
> Please ignore.Apparently the ocfnull was enabled along
> with the cryptosoft - that was the root cause of my
> problem.

No problems.

Cheers,
Davidm

> --- David McCullough
> <David_Mccullough@securecomputing.com> wrote:
> 
> > 
> > Jivin Eran Ben-Avi lays it down ...
> > > Hi,
> > > 
> > > Did anyone test latest OCF(20070727) with openssl
> > 0.9.8e ?
> > > I patched the OCF on kernel 2.6.23(rc) and
> > ssl.patch on openssl 0.9.8e
> > > and got errors when tried to perform key
> > decryption using cryptosoft driver.
> > > I tested it with older OCF on older
> > kernel(2.6.12.6) and it worked properly.
> > 
> > Which specific commands/openssl features were you
> > running so I can
> > reproduce it here ?  A lot of the openssl patch was
> > reworked to make
> > it more acceptable to send upstream as a patch.
> > 
> > The things I use regularly were tested,  but not
> > everything.  We have
> > fixed a couple of bugs since 20070727 so if I can
> > get some more
> > information it might be time to do a new version
> > with it fixed ;-)
> > 
> > Cheers,
> > Davidm
> > 
> > -- 
> > David McCullough, 
> > david_mccullough@securecomputing.com,   Ph:+61
> > 734352815
> > Secure Computing - SnapGear  http://www.uCdot.org
> > http://www.cyberguard.com
> > 
> 
> 
> 
>       ____________________________________________________________________________________
> Fussy? Opinionated? Impossible to please? Perfect.  Join Yahoo!'s user panel and lay it on us. http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 
> 

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
