From: Jan Varho <jan.varho@gmail.com>
Subject: Re: [PATCH 6/7] random: make /dev/urandom scalable for silly
 userspace programs
Date: Sun, 21 Aug 2016 12:53:15 +0300
Message-ID: <CABSDX40G2V9w-OfGU7xP06V5qkreq89CmdaJDc89b-2EskhCQg@mail.gmail.com>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu> <1465832919-11316-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        herbert@gondor.apana.org.au, andi@firstfloor.org,
        sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465832919-11316-7-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 13, 2016 at 6:48 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> +static inline void maybe_reseed_primary_crng(void)
> +{
> +       if (crng_init > 2 &&
> +           time_after(jiffies, primary_crng.init_time + CRNG_RESEED_INTERVAL))
> +               crng_reseed(&primary_crng, &input_pool);
> +}

Hi,

Is the above function (which is now in 4.8-rc2) supposed to do
something? It seems to have no callers and the maximum value of
crng_init is 2.
--
Jan Varho
