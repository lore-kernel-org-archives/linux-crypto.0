From: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: Is kernel optimized with dead store removal?
Date: Thu, 25 Feb 2010 16:14:01 +0100
Message-ID: <4B8693B9.3060102@gmail.com>
References: <4B85A49E.6000803@gmail.com> <19334.22971.970220.245930@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64581 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759037Ab0BYPTZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 10:19:25 -0500
In-Reply-To: <19334.22971.970220.245930@pilspetsen.it.uu.se>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


>  >  Does this optimization also occur during compilation of the Linux
>  >  kernel?

> Any such dead store removal is up to the compiler and the lifetime
> of the object being clobbered. For 'auto' objects the optimization
> is certainly likely.
> 
> This is only a problem if the memory (a thread stack, say) is recycled
> and leaked uninitialized to user-space, but such bugs are squashed
> fairly quickly upon discovery.

Thanks for comments,

In the sha1_update() case I don't know whether the stack is recycled and
leaked - it may be dependent on the calling function, but isn't it
vulnerable?

I tested this with the snippet below. If compiled with -O1 or -O2 and
ON_STACK defined 1, I can read "Secret" a second time. With ON_STACK
defined 0 I do not.

Roel

---
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
        memset(password, 0, 7);
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
