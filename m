From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Desynchronizing dm-raid1
Date: Mon, 12 May 2008 23:28:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0805122325050.373@engineering.redhat.com>
References: <E1JtKQL-0004Nm-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.64.0805061849020.7260@engineering.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: dm-devel@redhat.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0805061849020.7260@engineering.redhat.com>
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

On Tue, 6 May 2008, Mikulas Patocka wrote:

> On Tue, 6 May 2008, Herbert Xu wrote:
>
>> Mikulas Patocka <mpatocka@redhat.com> wrote:
>>> 
>>> BTW: is it guaranteed for crypto functions that they read the source data
>>> only once?
>> 
>> There is no such guarantee.
>> 
>> Cheers,
>
> So we'll have to copy the sector to temporary space before encrypting it.
>
> I'll look at it.
>
> Mikulas

Do you think that it would make sense to add a flag to crypto API that 
says that the encryption function reads the input only once? --- so that 
we wouldn't have to copy the data when using an algorithm which doesn't 
need it.

Or do you thint it would be useless (all major disk-encryption algorithms 
read input buffer more times?) or it would create too much code 
complexity?

Mikulas
