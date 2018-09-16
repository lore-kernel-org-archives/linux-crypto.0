From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v4 19/20] security/keys: rewrite big_key crypto
 to use Zinc
Date: Sun, 16 Sep 2018 02:29:35 +0200
Message-ID: <CAHmME9pjQroUEq3ORMSiQaS5acMTDOOcvDiOP6EAtABVkRZkVA@mail.gmail.com>
References: <20180914162240.7925-20-Jason@zx2c4.com> <201809160738.Z71qdjGu%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kbuild-all@01.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        David Howells <dhowells@redhat.com>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201809160738.Z71qdjGu%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey again Ro,

> 32bbe22e Jason A. Donenfeld 2018-09-14  49      imply KERNEL_MODE_NEON if CPU_V7

This shouldn't have ever been there anyway. Fixed now for v5.

Thanks,
Jason
