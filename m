From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Desynchronizing dm-raid1
Date: Fri, 23 May 2008 10:59:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0805231057110.31371@engineering.redhat.com>
References: <E1JtKQL-0004Nm-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.64.0805061849020.7260@engineering.redhat.com>
	<Pine.LNX.4.64.0805122325050.373@engineering.redhat.com>
	<20080513033822.GA9604@gondor.apana.org.au>
	<Pine.LNX.4.64.0805131622120.486@engineering.redhat.com>
	<20080514011457.GB18728@gondor.apana.org.au>
	<Pine.LNX.4.64.0805212210330.17520@engineering.redhat.com>
	<20080522024225.GA28400@gondor.apana.org.au>
	<Pine.LNX.4.64.0805220828500.15805@engineering.redhat.com>
	<20080522235345.GA4019@gondor.apana.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080522235345.GA4019@gondor.apana.org.au>
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

> On Thu, May 22, 2008 at 08:32:45AM -0400, Mikulas Patocka wrote:
>>
>> There may be external modules.
>
> Sorry but we don't support external modules.  They should be merged
> upstream rather than distributed in the wild.
>
> Cheers,

If you want to negate the meaning of the flag, then you have to write it 
yourself. I, as non-developer of crypto code, can prove that on given path 
the input data are read only once --- but I can't prove that on all paths 
and all possible chaining modes of algorithms the data are read once, 
because I don't know about all of them.

Mikulas
