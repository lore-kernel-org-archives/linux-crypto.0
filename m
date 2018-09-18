From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v5 00/20] WireGuard: Secure Network Tunnel
Date: Tue, 18 Sep 2018 11:28:50 -0700
Message-ID: <CAKv+Gu8doWS+BYzqoT7499CJX0hLm1jBSMfVxJoG3wsWFO7t1w@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180918161646.19105-1-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18 September 2018 at 09:16, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> v5 has the most comprehensive set of changes yet, and I think should
> finally address all of the relevant issues brought up on the mailing
> list. In particular, this feedback has come from:
>
>   - Andy Lutomirski
>   - Eric Biggers
>   - Ard Biesheuvel
>   - Kevin Easton
>   - Andrew Lunn
>   - Martin Willi
>
> Changes v4->v5:
> ---------------
>   - Use fewer inlines, except when measured as necessary.
>   - Reduce size of scattergather array to fit within stack on
>     small systems.
>   - Account for larger stack frames with KASAN.
>   - The x86_64 implementations are selected according to input length.
>   - Avoid using simd for small blocks on x86_64.
>   - The simd_get/put API is now pass by reference, so that the user
>     can lazily use the context based on whether or not it's needed.
>     See the description again in the first commit for this.
>   - Add cycle counts for different sizes for x86_64 commit messages.
>   - Relax simd during chapoly sg loop.
>   - Replace -include with #if defined(...)
>   - Saner and simpler Kconfig.
>   - Split into separate modules instead of one monolithic zinc.
>   - The combination of these three last items means that there no
>     longer are any conditionals in our Makefile.
>   - Martin showed a performance regression using tcrypt in v4. This
>     has been triaged and fixed, and now the Zinc code runs faster
>     than the previous code.
>   - While I initially wasn't going to do this for the initial
>     patchset, it was just so simple to do: now there's a nosimd
>     module parameter that can be used to disable simd instructions
>     for debugging and testing, or on weird systems.
>

I was going to respond in the other thread but it is probably better
to move the discussion here.

My concern about the monolithic nature of each algo module is not only
about SIMD, and it has nothing to do with weird systems. It has to do
with micro-architectural differences which are more common on ARM than
on other architectures *, I suppose. But generalizing from that, it
has to do with policy which is currently owned by userland and not by
the kernel. This will also be important for choosing between the time
variant but less safe table based scalar AES and the much slower time
invariant version (which is substantially slower, especially on
decryption) once we move AES into this library.

So a command line option for the kernel is not the solution here. If
we can't have separate modules, could we at least have per-module
options that put the policy decisions back into userland?

* as an example, the SHA256 NEON code I collaborated on with Andy
Polyakov 2 years ago is significantly faster on some cores and not on
others


> -----------------------------------------------------------
>
> This patchset is available on git.kernel.org in this branch, where it may be
> pulled directly for inclusion into net-next:
>
>   * https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/log/?h=jd/wireguard
>
> -----------------------------------------------------------
>
> WireGuard is a secure network tunnel written especially for Linux, which
> has faced around three years of serious development, deployment, and
> scrutiny. It delivers excellent performance and is extremely easy to
> use and configure. It has been designed with the primary goal of being
> both easy to audit by virtue of being small and highly secure from a
> cryptography and systems security perspective. WireGuard is used by some
> massive companies pushing enormous amounts of traffic, and likely
> already today you've consumed bytes that at some point transited through
> a WireGuard tunnel. Even as an out-of-tree module, WireGuard has been
> integrated into various userspace tools, Linux distributions, mobile
> phones, and data centers. There are ports in several languages to
> several operating systems, and even commercial hardware and services
> sold integrating WireGuard. It is time, therefore, for WireGuard to be
> properly integrated into Linux.
>
> Ample information, including documentation, installation instructions,
> and project details, is available at:
>
>   * https://www.wireguard.com/
>   * https://www.wireguard.com/papers/wireguard.pdf
>
> As it is currently an out-of-tree module, it lives in its own git repo
> and has its own mailing list, and every commit for the module is tested
> against every stable kernel since 3.10 on a variety of architectures
> using an extensive test suite:
>
>   * https://git.zx2c4.com/WireGuard
>     https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/WireGuard.git/
>   * https://lists.zx2c4.com/mailman/listinfo/wireguard
>   * https://www.wireguard.com/build-status/
>
> The project has been broadly discussed at conferences, and was presented
> to the Netdev developers in Seoul last November, where a paper was
> released detailing some interesting aspects of the project. Dave asked
> me after the talk if I would consider sending in a v1 "sooner rather
> than later", hence this patchset. A decision is still waiting from the
> Linux Plumbers Conference, but an update on these topics may be presented
> in Vancouver in a few months. Prior presentations:
>
>   * https://www.wireguard.com/presentations/
>   * https://www.wireguard.com/papers/wireguard-netdev22.pdf
>
> The cryptography in the protocol itself has been formally verified by
> several independent academic teams with positive results, and I know of
> two additional efforts on their way to further corroborate those
> findings. The version 1 protocol is "complete", and so the purpose of
> this review is to assess the implementation of the protocol. However, it
> still may be of interest to know that the thing you're reviewing uses a
> protocol with various nice security properties:
>
>   * https://www.wireguard.com/formal-verification/
>
> This patchset is divided into four segments. The first introduces a very
> simple helper for working with the FPU state for the purposes of amortizing
> SIMD operations. The second segment is a small collection of cryptographic
> primitives, split up into several commits by primitive and by hardware. The
> third shows usage of Zinc within the existing crypto API and as a replacement
> to the existing crypto API. The last is WireGuard itself, presented as an
> unintrusive and self-contained virtual network driver.
>
> It is intended that this entire patch series enter the kernel through
> DaveM's net-next tree. Subsequently, WireGuard patches will go through
> DaveM's net-next tree, while Zinc patches will go through Greg KH's tree.
>
> Enjoy,
> Jason
