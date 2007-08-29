From: Eran Ben-Avi <eranpublic@yahoo.com>
Subject: Re: OCF(20070727) cryptosoft errors with openssl 0.9.8e
Date: Wed, 29 Aug 2007 07:37:25 -0700 (PDT)
Message-ID: <913426.96574.qm@web62509.mail.re1.yahoo.com>
References: <20070829125325.GB30139@securecomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-crypto@vger.kernel.org, ocf-linux-users@lists.sourceforge.net
To: David McCullough <David_Mccullough@securecomputing.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web62509.mail.re1.yahoo.com ([69.147.75.101]:47389 "HELO
	web62509.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752616AbXH2Oh1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 10:37:27 -0400
In-Reply-To: <20070829125325.GB30139@securecomputing.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Please ignore.Apparently the ocfnull was enabled along
with the cryptosoft - that was the root cause of my
problem.

Thanks,
Eran Ben-Avi

--- David McCullough
<David_Mccullough@securecomputing.com> wrote:

> 
> Jivin Eran Ben-Avi lays it down ...
> > Hi,
> > 
> > Did anyone test latest OCF(20070727) with openssl
> 0.9.8e ?
> > I patched the OCF on kernel 2.6.23(rc) and
> ssl.patch on openssl 0.9.8e
> > and got errors when tried to perform key
> decryption using cryptosoft driver.
> > I tested it with older OCF on older
> kernel(2.6.12.6) and it worked properly.
> 
> Which specific commands/openssl features were you
> running so I can
> reproduce it here ?  A lot of the openssl patch was
> reworked to make
> it more acceptable to send upstream as a patch.
> 
> The things I use regularly were tested,  but not
> everything.  We have
> fixed a couple of bugs since 20070727 so if I can
> get some more
> information it might be time to do a new version
> with it fixed ;-)
> 
> Cheers,
> Davidm
> 
> -- 
> David McCullough, 
> david_mccullough@securecomputing.com,   Ph:+61
> 734352815
> Secure Computing - SnapGear  http://www.uCdot.org
> http://www.cyberguard.com
> 



      ____________________________________________________________________________________
Fussy? Opinionated? Impossible to please? Perfect.  Join Yahoo!'s user panel and lay it on us. http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 
