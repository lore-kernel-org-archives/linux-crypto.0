From: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in 	sha1_update()
Date: Thu, 25 Feb 2010 21:43:22 +0100
Message-ID: <4B86E0EA.5080102@gmail.com>
References: <4B8692E3.9030509@gmail.com>	 <19334.40337.651079.440912@pilspetsen.it.uu.se>	 <73c1f2161002250833n120cda05s9371e5ce13cc0aac@mail.gmail.com>	 <19334.44752.357207.382349@pilspetsen.it.uu.se> <73c1f2161002250932j5167e2fan51dc11970df00f7@mail.gmail.com> <4B86D3E4.4000205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Brian Gerst <brgerst@gmail.com>,
	Mikael Pettersson <mikpe@it.uu.se>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B86D3E4.4000205@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> Also from that document:
> 
> If you know how large the accessed memory is, you can add it as input or
> output but if this is not known, you should add memory. As an example, if
> you access ten bytes of a string, you can use a memory input like:
> 
>      {"m"( ({ struct { char x[10]; } *p = (void *)ptr ; *p; }) )}.
> 
> does this mean we could use something like:
> 
> #define SECURE_BZERO(x) do {                                            \
>         memset(x, 0, sizeof(x));                                        \
>         asm("" : :"m"( ({ struct { char __y[ARRAY_SIZE(x)]; } *__z =    \
>                                         (void *)x ; *__z; }) ));        \
> } while(0)

or rather for not just char arrays:

#define SECURE_BZERO(x) do {                                    \
        memset(x, 0, sizeof(x));                                \
        asm("" :: "m" ( ({                                      \
                        struct {                                \
                                typeof(x[0]) __y[ARRAY_SIZE(x)];\
                        } *__z = (void *)x;                     \
                        *__z;                                   \
                }) ));                                          \
} while(0)

This appears to work in my testcase:
---
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define SECURE 1

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

#define SECURE_BZERO(x) do {					\
	memset(x, 0, sizeof(x));				\
	asm("" :: "m" ( ({					\
			struct {				\
				typeof(x[0]) __y[ARRAY_SIZE(x)];\
			} *__z = (void *)x;			\
			*__z;					\
		}) ));						\
} while(0)

void foo()
{
	char password[] = "secret";
	password[0]='S';
	printf ("Don't show again: %s\n", password);
#if SECURE == 1
	SECURE_BZERO(password);
#else
	memset(password, 0, sizeof(password));
#endif
}

void foo1()
{
	int nrs[] = {1,1,2,3,4,5,6,7};
	nrs[0] = 0;
	int i = 8;
	printf ("Don't show again:\n");
	while (i--)
		printf ("%u\n", nrs[i]);
#if SECURE == 1
	SECURE_BZERO(nrs);
#else
	memset(nrs, 0, sizeof(nrs));
#endif
}

int main(int argc, char* argv[])
{

	foo();
	int i;
	char foo3[] = "";
	char* bar = &foo3[0];
	for (i = -50; i < 50; i++)
		printf ("%c.", bar[i]);
	printf("\n\n");

	foo1();
	int foo4 = 20;
	int* ber = &foo4;
	for (i = -50; i < 50; i++)
		printf ("%u_", ber[i]);
	printf("\n");
	return 0;
}
