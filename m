From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: dm-crypt optimization
Date: Tue, 20 Dec 2016 15:11:16 +0530
Message-ID: <CAHv-k_98w-9whFiCLAnTGL2QAirExsix_S8ZWc8tM7wj=gzD6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dm-devel@redhat.com, linux-crypto@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>
To: Milan Broz <gmazyland@gmail.com>, Oded <oded.golombek@arm.com>,
        Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, private-kwg@linaro.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

At a high level the goal is to maximize the size of data blocks that get passed
to hardware accelerators, minimizing the overhead from setting up and tearing
down operations in the hardware. Currently dm-crypt itself is a big blocker as
it manually implements ESSIV and similar algorithms which allow per-block
encryption of the data so the low level operations from the crypto API can
only operate on a single block. This is done because currently the crypto API
doesn't have software implementations of these algorithms itself so dm-crypt
can't rely on it being able to provide the functionality. The plan to address
this was to provide some software implementations in the crypto API, then
update dm-crypt to rely on those. Even for a pure software implementation
with no hardware acceleration that should hopefully provide a small
optimization as we need to call into the crypto API less often but it's likely
to be marginal given the overhead of crypto, the real win would be on a system
that has an accelerator that can replace the software implementation.

Currently dm-crypt handles data only in single blocks. This means that it can't
make good use of hardware cryptography engines since there is an overhead to
each transaction with the engine but transfers must be split into block sized
chunks. Allowing the transfer of larger blocks e.g. 'struct bio', could
mitigate against these costs and could improve performance in operating systems
with encrypted filesystems. Although qualcomm chipsets support another variant
of the device-mapper dm-req-crypt, it is not something generic and in
mainline-able state. Also, it only supports 'XTS-AES' mode of encryption and
is not compatible with other modes supported by dm-crypt.

However, there are some challenges and a few possibilities to address this. I
request you to provide your suggestions on whether the points mentioned below
makes sense and if it could be done differently.

1. Move the 'real' IV generation algorithms to crypto layer (e.g. essiv)
2. Increase the 'length' of the scatterlist nodes used in the crypto api. It
   can be made equal to the size of a main memory segment (as defined in
   'struct bio') as they are physcially contiguous.
3. Multiple segments in 'struct bio' can be represented as scatterlist of all
   segments in a 'struct bio'.

4. Move algorithms 'lmk' and 'tcw' (which are IV combined with hacks to the
   cbc mode) to create a customized cbc algorithm, implemented in a seperate
   file (e.g. cbc_lmk.c/cbc_tcw.c). As Milan suggested, these can't be treated
   as real IVs as these include hacks to the cbc mode (and directly manipulate
   encrypted data).

5. Move key selection logic to user space or always assume keycount as '1'
   (as mentioned in the dm-crypt param format below) so that the key selection
   logic does not have to be dependent on the sector number. This is necessary
   as the key is selected otherwise based on sector number:

   key_index = sector & (key_count - 1)

   If block size for scatterlist nodes are increased beyond sector boundary
   (which is what we plan to achieve, for performance), the key set for every
   cipher operation cannot be changed at the sector level.

   dm-crypt param format : cipher[:keycount]-mode-iv:ivopts
   Example               : aes:2-cbc-essiv:sha256

   Also as Milan suggested, it is not wise to move the key selection logic to
   the crypto layer as it will prevent any changes to the key structure later.

The following is a reference to an earlier patchset. It had the cipher mode
'cbc' mixed up with the IV algorithms and is usually not the preferred way.

Reference:
https://lkml.org/lkml/2016/12/13/65
https://lkml.org/lkml/2016/12/13/66
