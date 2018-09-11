From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography
 library
Date: Tue, 11 Sep 2018 16:57:39 -0700 (PDT)
Message-ID: <20180911.165739.2032677219588723041.davem@davemloft.net>
References: <20180911214737.GA81235@gmail.com>
        <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
        <20180911233015.GD11474@lunn.ch>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Jason@zx2c4.com, ebiggers@kernel.org, gregkh@linuxfoundation.org,
        ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, luto@kernel.org, sneves@dei.uc.pt,
        jeanphilippe.aumasson@gmail.com, linux-crypto@vger.kernel.org
To: andrew@lunn.ch
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911233015.GD11474@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 12 Sep 2018 01:30:15 +0200

> Just as an FYI:
> 
> 1) I don't think anybody in netdev has taken a serious look at the
> network code yet. There is little point until the controversial part
> of the code, Zinc, has been sorted out.
> 
> 2) I personally would be surprised if DaveM took this code without
> having an Acked-by from the crypto subsystem people. In the same way,
> i doubt the crypto people would take an Ethernet driver without having
> DaveM's Acked-by.

Both of Andrew's statements are completely true.

I'm not looking at any of the networking bits until the crypto stuff
is fully sorted and fully supported and Ack'd by crypto folks.
