From: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: LZO irreversible output?
Date: Thu, 04 Feb 2010 15:37:27 +1100
Message-ID: <4B6A4F07.3090509@crca.org.au>
References: <4B69ECE5.5060505@crca.org.au> <201002032354.11284.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	TuxOnIce Devel List <tuxonice-devel@lists.tuxonice.net>,
	LKML <linux-kernel@vger.kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201002032354.11284.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Rafael.

Rafael J. Wysocki wrote:
> On Wednesday 03 February 2010, Nigel Cunningham wrote:
>> Hi all.
>>
>> (Not sent to LKML yesterday; no reply from linux-crypto yet, so resending).
>>
>> A while back now, I stopped supplying the LZF compression algorithm with
>> TuxOnIce and made LZO the default algorithm. Around the same time, we
>> started getting occasional errors when reading images; decompression
>> failures.
>>
>> I've finally managed to find the time to properly look at this, and have
>> managed to find a data page that LZO compresses, but seems to be unable
>> to decompress back to the original contents. I'm wondering whether this
>> is because I'm doing something wrong, or because there really is some
>> data the LZO (or the kernel implementation) can't do reversible
>> compression on.
> 
> Well, FWIW, we have never had any problems with the userland LZO in s2disk,
> so if anything is wrong with LZO here, I guess it's the kernel code.

Okay. Guess I have to start shipping LZF again and make it the default
again then.

Regards,

Nigel
