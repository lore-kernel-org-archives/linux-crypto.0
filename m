From: roel kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in
	sha1_update()
Date: Thu, 25 Feb 2010 16:31:36 +0100
Message-ID: <25e057c01002250731q68bb9e28ld009163f2a009f48@mail.gmail.com>
References: <4B8692E3.9030509@gmail.com> <20100225.071759.98314060.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: herbert@gondor.apana.org.au, mikpe@it.uu.se,
	linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64567 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013Ab0BYPb7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 10:31:59 -0500
In-Reply-To: <20100225.071759.98314060.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 25, 2010 at 4:17 PM, David Miller <davem@davemloft.net> wrote:
> From: Roel Kluin <roel.kluin@gmail.com>
> Date: Thu, 25 Feb 2010 16:10:27 +0100
>
>> Due to optimization A call to memset() may be removed as a dead store when
>> the buffer is not used after its value is overwritten.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>
> Solution is wrong and overkill in my mind.
>
> It's overkill because the whole reason it's using a stack buffer is to
> avoid the overhead of a kmalloc() call.
>
> And it's wrong because the reason the memset() is there seems to be
> to clear out key information that might exist kernel stack so that
> it's more difficult for rogue code to get at things.

If the memset is optimized away then the clear out does not occur. Do you
know a different way to fix this? I observed this with:

$ gcc -O2 test.c;./a.out
and It shows (on my box) "...S.e.c.r.e.t..."

$ cat test.c

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define ON_STACK 1

void foo()
{
        char password[] = "secret";
        password[0]='S';
        printf ("Don't show again: %s\n", password);
        memset(password, 0, sizeof(password));
}

void foo2()
{
        char* password = malloc(7);
        strncpy (password, "secret" , 7);
        password[6] = '\0';
        password[0] = 'S';
        printf ("Don't show again: %s\n", password);
        //memset(password, 0, 7);
        free(password);

}

int main(int argc, char* argv[])
{

#if ON_STACK == 1
        foo();
#else
        foo2();
#endif
        int i;
        char foo3[] = "hoi";
        printf ("foo1:%s\n", foo3);
        char* bar = &foo3[0];
        for (i = -50; i < 50; i++)
                printf ("%c.", bar[i]);
        printf("\n");
        return 0;
}
