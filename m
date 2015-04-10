From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Fri, 10 Apr 2015 16:50:22 +0200
Message-ID: <2604864.n87lBBrmsR@tauon>
References: <20150318095345.GA12923@zoho.com> <2115964.QxtQ6rHSkc@tauon> <5527E22C.9080909@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5527E22C.9080909@iogearbox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 10. April 2015, 16:46:04 schrieb Daniel Borkmann:

Hi Daniel,

>On 04/10/2015 04:36 PM, Stephan Mueller wrote:
>> Am Freitag, 10. April 2015, 16:26:00 schrieb Hannes Frederic Sowa:
>...
>
>>> I suspected a problem in how volatile with non-present output args could
>>> be different, but this seems not to be the case.
>>> 
>>> I would contact llvm/clang mailing list and ask. Maybe there is a
>>> problem? It seems kind of strange to me...
>
>+1
>
>> Do you really think this is a compiler issue?
>
>If clang/LLVM advertises "GCC compatibility", then this would
>certainly be a different behavior.

As you wish. I will contact the clang folks. As the proposed fix is not super 
urgend, I think we can leave it until I got word from clang.

>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
