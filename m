From: Markus Huehnerbein <silencer@gmx.ch>
Subject: Re: Problem using dm-crypt with geode LX800 AES-Engine
Date: Wed, 29 Aug 2007 16:41:57 +0200
Message-ID: <46D585B5.9090607@gmx.ch>
References: <46D579AB.5040304@gmx.ch> <20070829141549.GD24782@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33416 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752232AbXH2OmA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 10:42:00 -0400
In-Reply-To: <20070829141549.GD24782@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Thanks a lot! I confirm that it works with "-s 128" and also if "-s" is
skipped! But if I try to use cryptsetup with ESSIV (cryptsetup -c
aes-cbc-essiv:sha256 -y -s 128 luksFormat /dev/hda2) I get the same
error. If the "geode-aes" does not support essiv why is this task not
performed by another algorithm in the cryptoAPI?

Thanks,
Markus

Sebastian Siewior wrote:
> * Markus Huehnerbein | 2007-08-29 15:50:35 [+0200]:
> 
>> I 've an embedded board with AMD Geode??? LX 800 Chip. I'm running Debian
>> Etch and Kernel 2.6.22.5. What I tried is to use dm-crypt /
>> cryptsetup-luks 1.0.5 with the Geode AES-Engine.
>>
>> The Kernel Modul "geode_aes" is compiled and loaded successfully. The
>> problem is, that if the module is loaded and I try:
>> 	cryptsetup -c aes -s 256 -h sha256 luksFormat /dev/hda2
> 
>>from a quick look into the source it should work with '-s 128' or
> without the -s parameter. Can you confirm this?
> 
> Sebastian
> -
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
