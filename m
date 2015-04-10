From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Fri, 10 Apr 2015 16:54:09 +0200
Message-ID: <5527E411.3090806@iogearbox.net>
References: <20150318095345.GA12923@zoho.com> <2115964.QxtQ6rHSkc@tauon> <5527E22C.9080909@iogearbox.net> <2604864.n87lBBrmsR@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:44786 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933648AbbDJOyS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 10:54:18 -0400
In-Reply-To: <2604864.n87lBBrmsR@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/10/2015 04:50 PM, Stephan Mueller wrote:
> Am Freitag, 10. April 2015, 16:46:04 schrieb Daniel Borkmann:
>
> Hi Daniel,
>
>> On 04/10/2015 04:36 PM, Stephan Mueller wrote:
>>> Am Freitag, 10. April 2015, 16:26:00 schrieb Hannes Frederic Sowa:
>> ...
>>
>>>> I suspected a problem in how volatile with non-present output args could
>>>> be different, but this seems not to be the case.
>>>>
>>>> I would contact llvm/clang mailing list and ask. Maybe there is a
>>>> problem? It seems kind of strange to me...
>>
>> +1
>>
>>> Do you really think this is a compiler issue?
>>
>> If clang/LLVM advertises "GCC compatibility", then this would
>> certainly be a different behavior.
>
> As you wish. I will contact the clang folks. As the proposed fix is not super
> urgend, I think we can leave it until I got word from clang.

Okay, that would be good, please let us know.

I believe there's certainly effort in the direction of an official
kernel clang/LLVM support, but not officially supported yet. If we
could get some clarification on the issue, even better.
