From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] crypto: testmgr: change `guard` to unsigned char
Date: Mon, 01 Jan 2018 07:03:46 -0800
Message-ID: <1514819026.1967.37.camel@perches.com>
References: <20180101103319.fmmlpeg6kjdmhloq@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org
To: Joey Pabalinas <joeypabalinas@gmail.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180101103319.fmmlpeg6kjdmhloq@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2018-01-01 at 00:33 -1000, Joey Pabalinas wrote:
> When char is signed, storing the values 0xba (186) and 0xad (173) in the
> `guard` array produces signed overflow. Change the type of `guard` to
> unsigned char to remove undefined behavior.
[]
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
[]
> @@ -185,7 +185,7 @@ static int ahash_partial_update(struct ahash_request **preq,
>  	char *state;
>  	struct ahash_request *req;
>  	int statesize, ret = -EINVAL;
> -	const char guard[] = { 0x00, 0xba, 0xad, 0x00 };
> +	const unsigned char guard[] = { 0x00, 0xba, 0xad, 0x00 };

Might as well add static too
