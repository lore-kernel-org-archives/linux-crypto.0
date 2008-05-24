From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Desynchronizing dm-raid1
Date: Sat, 24 May 2008 10:01:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0805240956400.18076@engineering.redhat.com>
References: <Pine.LNX.4.64.0805061849020.7260@engineering.redhat.com>
	<Pine.LNX.4.64.0805122325050.373@engineering.redhat.com>
	<20080513033822.GA9604@gondor.apana.org.au>
	<Pine.LNX.4.64.0805131622120.486@engineering.redhat.com>
	<20080514011457.GB18728@gondor.apana.org.au>
	<Pine.LNX.4.64.0805212210330.17520@engineering.redhat.com>
	<20080522024225.GA28400@gondor.apana.org.au>
	<Pine.LNX.4.64.0805220828500.15805@engineering.redhat.com>
	<20080522235345.GA4019@gondor.apana.org.au>
	<Pine.LNX.4.64.0805231057110.31371@engineering.redhat.com>
	<20080524000119.GA26747@gondor.apana.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080524000119.GA26747@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

>> If you want to negate the meaning of the flag, then you have to write it
>> yourself. I, as non-developer of crypto code, can prove that on given path
>> the input data are read only once --- but I can't prove that on all paths
>> and all possible chaining modes of algorithms the data are read once,
>> because I don't know about all of them.
>
> Huh? Inverting it would give exactly the same result as your current
> patch.  If you're not confident with it inverted, then I can't see
> how you could be confident about the patch as it is.

If you don't set the bit when it should be set => you get slight 
performance drop (problem 1)

You set the bit when it shouldn't be set => you get data corruption 
(problem 2)


Problem 1 is acceptable, problem 2 is not.

So if I forgot some code path when the bit should be set, I created 
problem 1, but I am sure that I didn't create problem 2.


If you invert the meaning of the bit, you risk creating problem 2. And you 
need more review (by someone who understands what all structures are being 
created in crypto code).

Mikulas
