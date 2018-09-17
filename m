From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.4.y] crypto: vmx - Fix sleep-in-atomic bugs
Date: Mon, 17 Sep 2018 13:47:15 +0200
Message-ID: <20180917114715.GG13057@kroah.com>
References: <20180910074204.10812-1-omosnace@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Ondrej Mosnacek <omosnace@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180910074204.10812-1-omosnace@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 10, 2018 at 09:42:04AM +0200, Ondrej Mosnacek wrote:
> commit 0522236d4f9c5ab2e79889cb020d1acbe5da416e upstream.
> 
> Conflicts:
>   drivers/crypto/vmx/
>     aes_cbc.c - adapted enable/disable calls to v4.4 state
>     aes_xts.c - did not exist yet in v4.4

We don't need these lines here...  I'll go hand edit it out...
