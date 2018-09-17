From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography
 library
Date: Sun, 16 Sep 2018 21:45:49 -0700 (PDT)
Message-ID: <20180916.214549.234387075817326903.davem@davemloft.net>
References: <20180911233015.GD11474@lunn.ch>
        <20180911.165739.2032677219588723041.davem@davemloft.net>
        <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: andrew@lunn.ch, Jason@zx2c4.com, ebiggers@kernel.org,
        gregkh@linuxfoundation.org, ard.biesheuvel@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sneves@dei.uc.pt, jeanphilippe.aumasson@gmail.com,
        linux-crypto@vger.kernel.org
To: luto@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 16 Sep 2018 21:09:11 -0700

> CRYPTO API
> M:      Herbert Xu <herbert@gondor.apana.org.au>
> M:      "David S. Miller" <davem@davemloft.net>
> L:      linux-crypto@vger.kernel.org
> 
> Herbert hasn't replied to any of these submissions.  You're the other
> maintainer :)

Herbert is the primary crypto maintainer, I haven't done a serious
review of crypto code in ages.

So yes, Herbert review is what is important here.
