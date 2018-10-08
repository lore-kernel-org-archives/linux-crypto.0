From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v7 03/28] zinc: introduce minimal cryptography
 library
Date: Mon, 8 Oct 2018 16:22:51 -0700
Message-ID: <20181008232250.GB164708@gmail.com>
References: <20181006025709.4019-1-Jason@zx2c4.com>
 <20181006025709.4019-4-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181006025709.4019-4-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Oct 06, 2018 at 04:56:44AM +0200, Jason A. Donenfeld wrote:
> Zinc stands for "Zinc Is Neat Crypto" or "Zinc as IN Crypto". It's also
> short, easy to type, and plays nicely with the recent trend of naming
> crypto libraries after elements. The guiding principle is "don't overdo
> it". It's less of a library and more of a directory tree for organizing
> well-curated direct implementations of cryptography primitives.
> 

As I've asked before: please Cc linux-crypto on the whole patch series,
including the cover letter.

- Eric
