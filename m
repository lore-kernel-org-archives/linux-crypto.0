From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 15/17] zinc: Curve25519 ARM implementation
Date: Tue, 28 Aug 2018 23:06:42 -0600
Message-ID: <CAHmME9rs+8kynZym=E4btqOu+Sh7MFn3kq7EPDXP27WzC9j_ZQ@mail.gmail.com>
References: <20180824213849.23647-1-Jason@zx2c4.com> <20180824213849.23647-16-Jason@zx2c4.com>
 <CAKv+Gu-WVOBZ1sQwOKo29P_jWL86wOnzd1-sB_6mTbPX1Lz0NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        "Daniel J . Bernstein" <djb@cr.yp.to>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-WVOBZ1sQwOKo29P_jWL86wOnzd1-sB_6mTbPX1Lz0NQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Ard,

Thanks for the thorough review. Very much appreciated. I've
incorporated nearly all of your suggestions into my development tree:

https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/tree/lib/zinc/curve25519/curve25519-arm.S?h=jd/wireguard

These changes will be part of v3.

Regards,
Jason
