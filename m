From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: md5sum (from libkcapi) fails as splice() returns -ENOKEY
Date: Tue, 12 Sep 2017 11:07:26 +0200
Message-ID: <6b0f315c-1414-0973-cdd9-4b17237c4362@c-s.fr>
References: <dadd0e10-f2e8-015a-a432-e7174331ab46@c-s.fr>
 <85331bd3-b799-f4a1-d1da-085be723f5cb@c-s.fr>
 <5590856.XjYaqbyTry@tauon.chronox.de> <2813810.Wx4icNXN4V@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:37414 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbdILJH2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2017 05:07:28 -0400
In-Reply-To: <2813810.Wx4icNXN4V@tauon.chronox.de>
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi again

Le 12/09/2017 à 09:22, Stephan Mueller a écrit :
> Am Dienstag, 12. September 2017, 09:20:41 CEST schrieb Stephan Mueller:
> 
>> I am thinking now to add AC_PREREQ([2.60]) to configure.ac.
> 
> I meant 2.69, of course? :-)

Ok ... CentOS ships with 2.63 and no update seems available via 'yum 
update'.

Is 2.69 really necessary ? It seems to work just fine with 2.63 once the 
modification is done.

Christophe


> 
> Ciao
> Stephan
> 
