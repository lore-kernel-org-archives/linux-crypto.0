From: Stephan Mueller <smueller@chronox.de>
Subject: Re: md5sum (from libkcapi) fails as splice() returns -ENOKEY
Date: Tue, 12 Sep 2017 11:11:24 +0200
Message-ID: <75276413.shWNmpB6es@tauon.chronox.de>
References: <dadd0e10-f2e8-015a-a432-e7174331ab46@c-s.fr> <2813810.Wx4icNXN4V@tauon.chronox.de> <6b0f315c-1414-0973-cdd9-4b17237c4362@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Christophe LEROY <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34698 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751311AbdILJL0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2017 05:11:26 -0400
In-Reply-To: <6b0f315c-1414-0973-cdd9-4b17237c4362@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 12. September 2017, 11:07:26 CEST schrieb Christophe LEROY:

Hi Christophe,

> Hi again
> 
> Le 12/09/2017 à 09:22, Stephan Mueller a écrit :
> > Am Dienstag, 12. September 2017, 09:20:41 CEST schrieb Stephan Mueller:
> >> I am thinking now to add AC_PREREQ([2.60]) to configure.ac.
> > 
> > I meant 2.69, of course? :-)
> 
> Ok ... CentOS ships with 2.63 and no update seems available via 'yum
> update'.
> 
> Is 2.69 really necessary ? It seems to work just fine with 2.63 once the
> modification is done.

Ok, then I will make that change, thanks for letting me know.
> 
> Christophe
> 
> > Ciao
> > Stephan



Ciao
Stephan
