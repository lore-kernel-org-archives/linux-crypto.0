From: roel kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in
	sha1_update()
Date: Thu, 25 Feb 2010 17:33:03 +0100
Message-ID: <25e057c01002250833n1e13391drfcc806df369c5a55@mail.gmail.com>
References: <4B8692E3.9030509@gmail.com> <19334.40337.651079.440912@pilspetsen.it.uu.se>
	<84144f021002250816o2c2cef0fke484c7e43256dba4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mikael Pettersson <mikpe@it.uu.se>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <84144f021002250816o2c2cef0fke484c7e43256dba4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 25, 2010 at 5:16 PM, Pekka Enberg <penberg@cs.helsinki.fi> =
wrote:
> On Thu, Feb 25, 2010 at 5:56 PM, Mikael Pettersson <mikpe@it.uu.se> w=
rote:
>> I fear that the only portable (across compiler versions) and safe
>> solution is to invoke an assembly-coded dummy function with prototyp=
e
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0void use(void *p);
>>
>> and rewrite the code above as
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 temp[...]=
;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(temp, =
0, sizeof temp);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0use(temp);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>
>> This forces the compiler to consider the buffer live after the
>> memset, so the memset cannot be eliminated.
>
> So is there some "do not optimize" GCC magic that we could use for a
> memzero_secret() helper function?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Pekka
>

        *(volatile char *)p =3D *(volatile char *)p;

appears to work when called after the memset:

---
inline void ensure_memset(void* p)
{
        *(volatile char *)p =3D *(volatile char *)p;
}

void foo()
{
        char password[] =3D "secret";
        password[0]=3D'S';
        printf ("Don't show again: %s\n", password);
        memset(password, 0, sizeof(password));
        ensure_memset(password);
}

int main(int argc, char* argv[])
{

        foo();
        int i;
        char foo3[] =3D "";
        char* bar =3D &foo3[0];
        for (i =3D -50; i < 50; i++)
                printf ("%c.", bar[i]);
        printf("\n");
        return 0;
}
