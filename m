From: Tobias Klauser <tklauser@distanz.ch>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 14:09:49 +0200
Message-ID: <20140717120949.GB24362@distanz.ch>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2014-07-17 at 11:18:15 +0200, Theodore Ts'o <tytso@mit.edu> wrote:

[...]

> +/*
> + * Flags for getrandom(2)
> + *
> + * GAND_BLOCK 		Allow getrandom(2) to block
> + * GAND_RANDOM		Use the /dev/random pool instead of /dev/urandom
> + */

Very minor nitpick: These should probably read GRND_BLOCK/GRND_RANDOM as
well, no?

> +#define GRND_BLOCK	0x0001
> +#define GRND_RANDOM	0x0002
> +
>  #endif /* _UAPI_LINUX_RANDOM_H */
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
