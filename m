From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Problem using dm-crypt with geode LX800 AES-Engine
Date: Wed, 29 Aug 2007 18:22:00 +0200
Message-ID: <20070829162200.GE24782@Chamillionaire.breakpoint.cc>
References: <46D579AB.5040304@gmx.ch> <20070829141549.GD24782@Chamillionaire.breakpoint.cc> <46D585B5.9090607@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Markus Huehnerbein <silencer@gmx.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40843 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685AbXH2QWC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 12:22:02 -0400
Content-Disposition: inline
In-Reply-To: <46D585B5.9090607@gmx.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Markus Huehnerbein | 2007-08-29 16:41:57 [+0200]:

>Thanks a lot! I confirm that it works with "-s 128" and also if "-s" is
>skipped! But if I try to use cryptsetup with ESSIV (cryptsetup -c
>aes-cbc-essiv:sha256 -y -s 128 luksFormat /dev/hda2) I get the same
what about sha128 instead?

>error. If the "geode-aes" does not support essiv why is this task not
>performed by another algorithm in the cryptoAPI?
Actually it is. geode does not support keys != 128 bit. ESSIV uses as
key the output of sha256 what is 256. Check dmesg please. If my theory
is correct than you should see in dmesg or somewhere:
"Failed to set key for ESSIV cipher"
Is it?

>Thanks,
>Markus

Sebastian
