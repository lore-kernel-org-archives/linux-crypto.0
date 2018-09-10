From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/4] crypto: arm64/aes-blk - cleanups and optimizations for
 XTS/CTS-CBC
Date: Mon, 10 Sep 2018 16:41:11 +0200
Message-ID: <20180910144115.25727-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Theodore Ts'o <tytso@mit.edu>,
 herbert@gondor.apana.org.au, Steve Capper <steve.capper@arm.com>,
 Eric Biggers <ebiggers@google.com>, linux-arm-kernel@lists.infradead.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Some cleanups and optimizations for the arm64  AES skcipher routines.

Patch #1 fixes the peculiar use of u8 arrays to refer to AES round keys,
which are natively arrays of u32.

Patch #2 partially reverts the use of NEON yield calls, which is not
needed for skciphers.

Patch #3 adds support for cts(cbc(aes)) in the NEON chaining mode handling.

Patch #4 tweaks the XTS handling to remove a literal load from the inner
loop.

Cc: Eric Biggers <ebiggers@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Steve Capper <steve.capper@arm.com>

Ard Biesheuvel (4):
  crypto: arm64/aes-blk - remove pointless (u8 *) casts
  crypto: arm64/aes-blk - revert NEON yield for skciphers
  crypto: arm64/aes-blk - add support for CTS-CBC mode
  crypto: aes/arm64-blk - improve XTS mask handling

 arch/arm64/crypto/aes-ce.S    |   5 +
 arch/arm64/crypto/aes-glue.c  | 212 +++++++++--
 arch/arm64/crypto/aes-modes.S | 400 ++++++++++----------
 arch/arm64/crypto/aes-neon.S  |   6 +
 4 files changed, 406 insertions(+), 217 deletions(-)

-- 
2.18.0
