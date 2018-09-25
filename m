From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Tue, 25 Sep 2018 16:55:59 +0200
Message-ID: <20180925145622.29959-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Changes v5->v6, along with who suggested it.
--------------------------------------------
  - [Eric Biggers] Cleaner and more efficient blake2s_final function.
  - [Eric Biggers] Remove modulo trick that was working around a gcc 8.1 bug.
  - [Eric Biggers] Use crypto_xor_cpy to avoid a memmove in chacha20.
  - In the unlikely condition that we transition from SIMD back to scalar
    instructions for Poly1305, it's important that we also convert back
    from base 2^26 to 2^64. This is super rare and weird, and it's hard
    to imagine somebody actually doing this for whatever bad reason, but
    it is a possibility, so we shouldn't calculate things wrong in that
    instance.
  - [Andrew Lunn] Change BUG_ON to WARN_ON in choice places.
  - [Thomas Gleixner] Explicitly dual license files under X where X≠GPL2
    to be under X && GPL2.
  - [Andy Lutomirski] Use separate symbols for selftests that are of
    variable length, so that we neither waste space on disk nor waste space
    in memory (via __initconst).
  - [Thomas Gleixner] Make SPDX headers a standalone comment, and use the
    // commenting style in .h files, per the kernel style guide.
  - [Paul Burton] Allow assembler to fill branch delay slots on MIPS32r2,
    so that the implementation is more future-proof.
  - [Eric Biggers] Use Eric's scalar implementation for ChaCha20 ARM, which
    performs very well for Cortex-A7,5 and ARMv6, while using Andy
    Polyakov's NEON implementation for other ARMv7.
  - [Ard Biesheuvel] Reduce optimization from -O3 to -O2.
  - [Arn?d Bi?e(rgmann|shuvel)] Make sure stack frames stay inside 1024
    bytes on 32-bit and 1280 bytes on 64-bit.
  - [Ard Biesheuvel] CRYPTOGAMS-related commit messages now have the
    corresponding OpenSSL commit written in them.
  - [Eric Biggers] Keep HChaCha20 key in native endian, since in some
    cases it can trivially be passed into the ChaCha20 block later.
  - Make constants follow a consistent naming scheme.
  - Workaround gcc 8 stack mis-optimization on m68k.
  - [Arnd Bergmann] Workaround gcc 8 stack mis-optimization with KASAN.

Many of the above ARM changes are a result of discussions between Ard,
Eric, AndyL, AndyP, Samuel, and me. These discussions are ongoing, and so
it's possible we'll do another revision with further ARM tweaks. But perhaps
this one will be sufficient for merging now, and we can continue to refine
later in the cycle.

-----------------------------------------------------------

This patchset is available on git.kernel.org in this branch, where it may be
pulled directly for inclusion into net-next:

  * https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/log/?h=jd/wireguard

-----------------------------------------------------------

WireGuard is a secure network tunnel written especially for Linux, which
has faced around three years of serious development, deployment, and
scrutiny. It delivers excellent performance and is extremely easy to
use and configure. It has been designed with the primary goal of being
both easy to audit by virtue of being small and highly secure from a
cryptography and systems security perspective. WireGuard is used by some
massive companies pushing enormous amounts of traffic, and likely
already today you've consumed bytes that at some point transited through
a WireGuard tunnel. Even as an out-of-tree module, WireGuard has been
integrated into various userspace tools, Linux distributions, mobile
phones, and data centers. There are ports in several languages to
several operating systems, and even commercial hardware and services
sold integrating WireGuard. It is time, therefore, for WireGuard to be
properly integrated into Linux.

Ample information, including documentation, installation instructions,
and project details, is available at:

  * https://www.wireguard.com/
  * https://www.wireguard.com/papers/wireguard.pdf

As it is currently an out-of-tree module, it lives in its own git repo
and has its own mailing list, and every commit for the module is tested
against every stable kernel since 3.10 on a variety of architectures
using an extensive test suite:

  * https://git.zx2c4.com/WireGuard
    https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/WireGuard.git/
  * https://lists.zx2c4.com/mailman/listinfo/wireguard
  * https://www.wireguard.com/build-status/

The project has been broadly discussed at conferences, and was presented
to the Netdev developers in Seoul last November, where a paper was
released detailing some interesting aspects of the project. Dave asked
me after the talk if I would consider sending in a v1 "sooner rather
than later", hence this patchset. A decision is still waiting from the
Linux Plumbers Conference, but an update on these topics may be presented
in Vancouver in a few months. Prior presentations:

  * https://www.wireguard.com/presentations/
  * https://www.wireguard.com/papers/wireguard-netdev22.pdf

The cryptography in the protocol itself has been formally verified by
several independent academic teams with positive results, and I know of
two additional efforts on their way to further corroborate those
findings. The version 1 protocol is "complete", and so the purpose of
this review is to assess the implementation of the protocol. However, it
still may be of interest to know that the thing you're reviewing uses a
protocol with various nice security properties:

  * https://www.wireguard.com/formal-verification/

This patchset is divided into four segments. The first introduces a very
simple helper for working with the FPU state for the purposes of amortizing
SIMD operations. The second segment is a small collection of cryptographic
primitives, split up into several commits by primitive and by hardware. The
third shows usage of Zinc within the existing crypto API and as a replacement
to the existing crypto API. The last is WireGuard itself, presented as an
unintrusive and self-contained virtual network driver.

It is intended that this entire patch series enter the kernel through
DaveM's net-next tree. Subsequently, WireGuard patches will go through
DaveM's net-next tree, while Zinc patches will go through Greg KH's tree.

Enjoy,
Jason
