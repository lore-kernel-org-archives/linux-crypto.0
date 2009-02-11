From: Valentin QUEQUET <v.quequet-techniques@orange.fr>
Subject: Re: [dm-devel] Re: [Bugme-new] [Bug 12680] New: Not having a VIA
 PadLock hardware incurs a long delay in probing on modules insertion attempt.
Date: Wed, 11 Feb 2009 21:55:36 +0100
Message-ID: <49933B48.1090905@orange.fr>
References: <bug-12680-10286@http.bugzilla.kernel.org/>	<20090209130536.9a7a87cd.akpm@linux-foundation.org>	<4992FC7E.3010207@orange.fr> <20090211091647.6607aea4.akpm@linux-foundation.org> <499326D4.5060005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: device-mapper development <dm-devel@redhat.com>,
	linux-crypto@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.18]:33931 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467AbZBKU7Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Feb 2009 15:59:25 -0500
In-Reply-To: <499326D4.5060005@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Note : My answer(s) follow(s) Milan's post,
          with a few exceptions sclattered throughout his reply, but 
resumed further though.

Milan Broz wrote :
> Andrew Morton wrote:
>> (cc dm-devel)
>>
>> On Wed, 11 Feb 2009 17:27:42 +0100 Valentin QUEQUET <v.quequet-techniques@orange.fr> wrote:
>>
>>> I've finally found why my computer seems to hang (pause) quite lengthy 
>>> when I boot Pristine Linux 2.6.29-rcX... instead of Pristine Linux 
>>> 2.6.28.4 (for example).
>>>
>>> The reason is that the cryptographic keys generation for the Device 
>>> Mapper takes longer with 2.6.29 than with 2.6.28 under certain 
>>> circumstances.
>> So it's device-mapper userspace?

I don't know ; sorry for not knowing everything.

> 
> No. cryptsetup (which is probably "device-mapper userspace" here) reads
> /dev/random only during luksFormat or during manipulating with keyslots
> (adding key for example).
> 
> The situation you are talking about is when you have for example swap
> encrypted with random key. It is initscripts which owns /etc/crypttab
> and which just tell cryptsetup "use /dev/random as keyfile".

I use the following config file under Debian Lenny/Sid :

Config File "/etc/intitab" contains:

{

   # <target name> <source device>         <key file>      <options>
   crswap_hda2 /dev/hda2 /dev/random swap,cipher=aes-cbc-essiv:sha256
   crtmp_hda5 /dev/hda5 /dev/random tmp,cipher=aes-cbc-essiv:sha256

}

> Also initscripts are responsible for loading of random seed to 
> properly initialize RNG *before* this.
> 
> Most distributions uses two steps - mount volume with /var
> (where is the random seed stored) and later mount encrypted volumes
> using random key.

I didn't know that either ; excuse, please, my great ignorance.

> I do not know if the delay in new kernel is bug, but the problem
> with lack of entropy during system boot is "known" problem.
> (Imagine 128bit random key which use fast-generated key with only
> few random bits because of lack of entropy... better to not
> use encryption at all then use such key!)

It's even not a problem ; one must know that GOOD RANDOMNESS requires 
TIME to collect ENVIRONMENTAL NOISE ; and that TRUE RANDOMNESS is 
impossible without a dedicated device like a Lava Lamp, ... .

> (if you use LUKS, the random key is generated during luksFormat and
> you do not need random data (entropy) on activation, you just need
> enter known passphrase to unlock keyslot with the volume key.)

I don't plan this alternative though.

However, I consider PassPhrase-Seeded cryptographic keys for some 
purpose, maybe, but NOT FOR SWAP or /TMP directory. (In case of a 
keylogger ...)

> Milan
> --
> mbroz@redhat.com

Hello the hurd,

To resume, 2.6.29-rcX is harder than 2.6.28.Y at providing /dev/random 
output towards userspace.

Maybe, the kernel itself makes a personal use of this entropy pool for, 
let's say, processes' memory layout randomization ??????

I know nothing about Dear Linux kernel !


In hope my report will prove useful,

Sincerely,
Valentin QUEQUET


