From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: LZO irreversible output?
Date: Sun, 07 Feb 2010 17:23:39 -0500
Message-ID: <hkneh9$djl$1@ger.gmane.org>
References: <4B69ECE5.5060505@crca.org.au> <201002032354.11284.rjw@sisk.pl> <4B6A4F07.3090509@crca.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tuxonice-devel@lists.tuxonice.net
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A4F07.3090509@crca.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Nigel Cunningham wrote:
> Hi Rafael.
> 
> Rafael J. Wysocki wrote:
>> On Wednesday 03 February 2010, Nigel Cunningham wrote:
>>> Hi all.
>>>
>>> (Not sent to LKML yesterday; no reply from linux-crypto yet, so resending).
>>>
>>> A while back now, I stopped supplying the LZF compression algorithm with
>>> TuxOnIce and made LZO the default algorithm. Around the same time, we
>>> started getting occasional errors when reading images; decompression
>>> failures.
>>>
>>> I've finally managed to find the time to properly look at this, and have
>>> managed to find a data page that LZO compresses, but seems to be unable
>>> to decompress back to the original contents. I'm wondering whether this
>>> is because I'm doing something wrong, or because there really is some
>>> data the LZO (or the kernel implementation) can't do reversible
>>> compression on.
>> Well, FWIW, we have never had any problems with the userland LZO in s2disk,
>> so if anything is wrong with LZO here, I guess it's the kernel code.
> 
> Okay. Guess I have to start shipping LZF again and make it the default
> again then.
> 
I would hope someone will look at the real problem, though, that LZO isn't 
working properly. I have to assume that either the kernel decompress is broken 
or that the page you have given is invalid, and the error lies in the compression.

It doesn't look as if you are doing something wrong, it looks broken.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
