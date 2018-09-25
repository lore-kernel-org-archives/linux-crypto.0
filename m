From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next v6 02/23] zinc: introduce minimal cryptography
 library
Date: Tue, 25 Sep 2018 11:33:49 -0700
Message-ID: <2b5f2df2f1278c118a913259a44efdf589719293.camel@perches.com>
References: <20180925145622.29959-1-Jason@zx2c4.com>
         <20180925145622.29959-3-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Samuel Neves <sneves@dei.uc.pt>, Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180925145622.29959-3-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2018-09-25 at 16:56 +0200, Jason A. Donenfeld wrote:
> Zinc stands for "Zinc Is Neat Crypto" or "Zinc as IN Crypto" or maybe
> just "Zx2c4's INsane Cryptolib." It's also short, easy to type, and
> plays nicely with the recent trend of naming crypto libraries after
> elements. The guiding principle is "don't overdo it". It's less of a
> library and more of a directory tree for organizing well-curated direct
> implementations of cryptography primitives.
[]
> diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
> new file mode 100644
> index 000000000000..a61c80d676cb
> --- /dev/null
> +++ b/lib/zinc/Makefile
> @@ -0,0 +1,3 @@
> +ccflags-y := -O2
> +ccflags-y += -D'pr_fmt(fmt)="zinc: " fmt'
> +ccflags-$(CONFIG_ZINC_DEBUG) += -DDEBUG

I think the -Dpr_fmt is especially odd and not
really acceptable as it not used anywhere else
in the kernel.
