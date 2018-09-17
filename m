From: Horia Geanta <horia.geanta@nxp.com>
Subject: Re: [PATCH v2] [v2] crypto: aes-generic - fix aes-generic regression
 on powerpc
Date: Mon, 17 Sep 2018 09:18:37 +0000
Message-ID: <VI1PR0402MB34855F454AA1D324ABEC0090981E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20180115160735.593519-1-arnd@arndb.de>
 <20180120004425.GA6484@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 1/20/2018 2:44 AM, Herbert Xu wrote:=0A=
> On Mon, Jan 15, 2018 at 05:07:22PM +0100, Arnd Bergmann wrote:=0A=
>> My last bugfix added -Os on the command line, which unfortunately caused=
=0A=
>> a build regression on powerpc in some configurations.=0A=
>>=0A=
>> I've done some more analysis of the original problem and found slightly=
=0A=
>> different workaround that avoids this regression and also results in=0A=
>> better performance on gcc-7.0: -fcode-hoisting is an optimization step=
=0A=
>> that got added in gcc-7 and that for all gcc-7 versions causes worse=0A=
>> performance.=0A=
>>=0A=
>> This disables -fcode-hoisting on all compilers that understand the optio=
n.=0A=
>> For gcc-7.1 and 7.2 I found the same performance as my previous patch=0A=
>> (using -Os), in gcc-7.0 it was even better. On gcc-8 I could see no=0A=
>> change in performance from this patch. In theory, code hoisting should=
=0A=
>> not be able make things better for the AES cipher, so leaving it=0A=
>> disabled for gcc-8 only serves to simplify the Makefile change.=0A=
>>=0A=
>> Reported-by: kbuild test robot <fengguang.wu@intel.com>=0A=
>> Link: https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg30418=
.html=0A=
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D83356=0A=
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D83651=0A=
>> Fixes: 148b974deea9 ("crypto: aes-generic - build with -Os on gcc-7+")=
=0A=
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>=0A=
> =0A=
> Patch applied.  Thanks.=0A=
> =0A=
This fix ("commit 6e36719fbe90213fbba9f50093fa2d4d69b0e93c upstream") is ne=
eded=0A=
also in 4.14.y stable tree, since it contains commit=0A=
7cae67e31292 ("crypto: aes-generic - build with -Os on gcc-7+")=0A=
=0A=
Compilation fails without it:=0A=
crypto/aes_generic.o: In function `crypto_aes_set_key':=0A=
crypto/aes_generic.c:1300: undefined reference to `_restgpr_31_x'=0A=
=0A=
Thanks,=0A=
Horia=0A=
