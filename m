From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v4 18/20] crypto: port ChaCha20 to Zinc
Date: Mon, 17 Sep 2018 06:54:26 +0200
Message-ID: <CAHmME9orPSvUH3dmnBvRfy_TEBoLO5VNHEMXaMo9a1WGP-rcXg@mail.gmail.com>
References: <20180914162240.7925-1-Jason@zx2c4.com> <20180914162240.7925-19-Jason@zx2c4.com>
 <72e893e7efbef428d4fd23b7332d9e829acd5e7d.camel@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <72e893e7efbef428d4fd23b7332d9e829acd5e7d.camel@strongswan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Martin,

Thanks for running these and pointing this out. I've replicated the
results with tcrypt and fixed some issues, and the next patch series
should be a lot closer to what you'd expect, instead of the regression
you noticed. Most of the slowdown happened as a result of over-eager
XSAVEs, which I've now rectified. I'm still working on a few other
facets of it, but I believe v5 will be more satisfactory when posted.

Regards,
Jason
