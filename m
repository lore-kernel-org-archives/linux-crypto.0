From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Desynchronizing dm-raid1
Date: Thu, 22 May 2008 08:32:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0805220828500.15805@engineering.redhat.com>
References: <E1JtKQL-0004Nm-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.64.0805061849020.7260@engineering.redhat.com>
	<Pine.LNX.4.64.0805122325050.373@engineering.redhat.com>
	<20080513033822.GA9604@gondor.apana.org.au>
	<Pine.LNX.4.64.0805131622120.486@engineering.redhat.com>
	<20080514011457.GB18728@gondor.apana.org.au>
	<Pine.LNX.4.64.0805212210330.17520@engineering.redhat.com>
	<20080522024225.GA28400@gondor.apana.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080522024225.GA28400@gondor.apana.org.au>
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

>> All the ciphers comply, so the bug is only a theroretical issue (but I
>> didn't check assembler versions --- they should be checked by the person
>> who wrote them, assembler is write-only language).
>
> Since every current algorithm sets the flag could you invert
> its sense? Sorry to have to do this to you :)
>
> Thanks,

There may be external modules.

If you don't set the flag when it should be set, nothing happens (just a 
slight performance drop), if you set the flag when it shouldn't be set, 
you get data corruption. So the safest way is this meaning of flag, so 
that not-yet-reviewed algorithms set the flag to 0 and prevent data 
corruption.

Mikulas
