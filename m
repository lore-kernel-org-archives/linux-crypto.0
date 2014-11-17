From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: Re: [PATCH 1/2] scripts/coccinelle: catch freeing cryptographic
 structures via kfree
Date: Mon, 17 Nov 2014 18:40:40 +0300
Message-ID: <546A16F8.4000604@samsung.com>
References: <20141117151420.10739.16342.stgit@buzz>
 <alpine.DEB.2.10.1411171628230.2532@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	Eric Biederman <ebiederm@xmission.com>,
	Michal Marek <mmarek@suse.cz>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Gilles Muller <Gilles.Muller@lip6.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.2.10.1411171628230.2532@hadrien>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On 2014-11-17 18:30, Julia Lawall wrote:
>
> On Mon, 17 Nov 2014, Konstantin Khlebnikov wrote:
>
>> Structures allocated by crypto_alloc_* must be freed using crypto_free_*.
>>
>> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
>> ---
>>   scripts/coccinelle/free/crypto_free.cocci |   45 +++++++++++++++++++++++++++++
>>   1 file changed, 45 insertions(+)
>>   create mode 100644 scripts/coccinelle/free/crypto_free.cocci
>>
>> diff --git a/scripts/coccinelle/free/crypto_free.cocci b/scripts/coccinelle/free/crypto_free.cocci
>> new file mode 100644
>> index 0000000..0799b70
>> --- /dev/null
>> +++ b/scripts/coccinelle/free/crypto_free.cocci
>> @@ -0,0 +1,45 @@
>> +///
>> +/// Structures allocated by crypto_alloc_* must be freed using crypto_free_*.
>> +/// This finds freeing them by kfree.
>> +///
>> +// Confidence: Moderate
>> +// Copyright: (C) 2014 Konstantin Khlebnikov,  GPLv2.
>> +// Comments: There are false positives in crypto/ where they are actually freed.
>> +// Keywords: crypto, kfree
>> +// Options: --no-includes --include-headers
>> +
>> +virtual org
>> +virtual report
>> +virtual context
>> +
>> +@r depends on context || org || report@
>> +expression x;
>> +identifier crypto_alloc =~ "^crypto_alloc_";
>> +@@
>> +
>> +(
>> + x = crypto_alloc(...)
>> +)
> You can drop the outer parentheses, in this case and in the kfree case.
>
> Are there many of these crypto_alloc_ functions?  It would be nicer to
> avoid the regular expression.  For one thing, you don't have much control
> over what it matches, and for another thing Coccinelle will not be able to
> optimize the selection of files.  With the regular expression it will have
> to parse every file and analyze every function, which will be slow.

As I see here is eight .. ten candidates, maybe some of them are internal.
Ok, I'll resend patch without regex.

>
> julia
>
>> +
>> +@pb@
>> +expression r.x;
>> +position p;
>> +@@
>> +
>> +(
>> +* kfree@p(x)
>> +)
>> +
>> +@script:python depends on org@
>> +p << pb.p;
>> +@@
>> +
>> +msg="WARNING: invalid free of crypto_alloc_* allocated data"
>> +coccilib.org.print_todo(p[0], msg)
>> +
>> +@script:python depends on report@
>> +p << pb.p;
>> +@@
>> +
>> +msg="WARNING: invalid free of crypto_alloc_* allocated data"
>> +coccilib.report.print_report(p[0], msg)
>>
>>
