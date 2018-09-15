From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v4 20/20] net: WireGuard secure network tunnel
Date: Sun, 16 Sep 2018 01:48:46 +0200
Message-ID: <CAHmME9p9z_aO_9FS7ouCOPG3dCENgBPzUs=Rc0ciaiY9kCK3RA@mail.gmail.com>
References: <20180914162240.7925-21-Jason@zx2c4.com> <201809160701.EQDrNg4f%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kbuild-all@01.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201809160701.EQDrNg4f%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Mr. Ro Bot,

Looks like this is related to stack frames with KASAN. I've fixed this for v5.

Thanks,
Jason
