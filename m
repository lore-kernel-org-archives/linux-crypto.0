Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695B04B5C1
	for <linux-crypto@vger.kernel.org>; Thu, 21 Nov 2024 14:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732199825; cv=none; b=bvXXQnvS2FAcer8Dg3GCJxe6/5mobMPRJ/Y2WebsS07NnzrQNVBe0C7q1yaV+1JtOncdOTqyT+u1QicNBGYR4wdVpNEsfUoAQm5N5fQ4WfYLx9/MBJMbHIEzvNoLdLem0DdzXZf/7dso5sfAWdZl7smES4Y8QJydFiiqQikTCwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732199825; c=relaxed/simple;
	bh=j2gW8/dzad7O4ifv8C6hL7GRf1jsQPraPn3cGS4SvTk=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=JiXCDDsQJanDG+LqApwT37zrv4I9c3dyQr9Uj/Bjiosxbv/qPvW1ZfBnsxEQg4njAEW597yWXAXFYQtFENR1/gUYqiymAxP1HfrTaa8QytJ9RFS5joCvMnB/YHXukcvwWVaOLOSqdT4VcMHyf86VfAZIqqKZnCZYufihY6oPZRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ruabmbua.dev; spf=pass smtp.mailfrom=ruabmbua.dev; dkim=pass (2048-bit key) header.d=ruabmbua.dev header.i=@ruabmbua.dev header.b=qamZ6jDg; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ruabmbua.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ruabmbua.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ruabmbua.dev header.i=@ruabmbua.dev header.b="qamZ6jDg"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4XvLJ41n7yz9tmx;
	Thu, 21 Nov 2024 15:31:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ruabmbua.dev;
	s=MBO0001; t=1732199460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/gp/IwCLdyD7Lx9Db8fGM+f1cT+Tmb5WTc11iHdLPUM=;
	b=qamZ6jDgoE5I8kKmcz5C2BOSOqh9te8buQZ/DDJgZ1DlzP8CZUp5Cn1+L2GcPgTOJCkRP8
	eQlCsB1AO+kyFXXlbTHfxJ1poqfimTi3ovhdmhxcQ6gpF6QZXFS+0TazIubnqSVkyMYxe3
	Q7Fl/pcvkqVmgF15swOv5CsLuTHbXnPP4R2ZrxFW6LQxZIN1csc0JEjQ7e5COHOKJBvs8R
	SJdGy4rsf/+U2kIxrMHt8PKsBeJ6KPQgszSr3qbn1NB2D/KordVsegooA0NNP2Doskv8EM
	erThGBA8y2QGpH3Qh6CXsEjkQk8+mQqOS8qvjKz7bVm0OJoSsrtpU5bk5Np0hg==
Date: Thu, 21 Nov 2024 15:30:58 +0100 (CET)
From: Roland Ruckerbauer <mail@ruabmbua.dev>
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Message-ID: <1888185700.1153044.1732199458909@office.mailbox.org>
Subject: sporadic CAAM Invalid Sequence Command errors on aes-128-cbc
 encrypt & decrypt
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal

Hi Horia, Pankaj, Gaurav, and mailing list!

I am hitting a problem on 5.10 stable kernel (with PREEMPT_RT patches applied).
The hardware I am testing on is a imx6q SoC, with an era 4 CAAM module:
[    4.023362] caam 2100000.crypto: device ID = 0x0a16010000000000 (Era 4)
[    4.023379] caam 2100000.crypto: job rings = 1, qi = 0

The problem manifests itself as I/O errors on a device mapper device using capi:tk(cbc(aes))-plain
and capi:cbc(aes)-plain ciphers. I came to the conclusion, that all these errors are exclusively
caused by the caam driver crypto API implementation, called by the device mapper. Here is an
example for one of the errors:
[ 4855.666389] caam_jr 2102000.jr: 40001210: DECO: desc idx 13: Invalid Sequence Command. A SEQ IN PTR OR SEQ OUT PTR Command is invalid or a SEQ KEY, SEQ LOAD, SEQ FIFO LOAD, or SEQ FIFO STORE decremented the input or output sequence length below 0. This error may result if a built-in PROTOCOL Command has encountered a malformed PDU.

I managed to figure out it can be reproduced more reliably using e.g. stress-ng --vm 4 --vm-bytes 50M.
I also created a small userspace utility, which seems to be able to trigger the bug even faster when
used in addition to the memory stress program. I appended the program to the bottom of the email.

For analyzing the problem, I started trying out different things in the driver, and also reading
through the IMX6DQ6SDLSRM Rev. D, 11/2012 manual (security reference manual).

After doing many tests including creating slightly different versions of the shared job descriptor
for cnstr_shdsc_skcipher_{encap,decap}, I came to the conclusion, that in certain situations the
SEQINLEN (and SEQOUTLEN) registers in the DECO must have the wrong value, or writing to the VLI
registers (VARSEQOUTLEN and VARSEQINLEN) does not properly work sometimes.

Here is a list of stuff I tried / tested:

1) Always doing a complete dump of all submitted data / descriptors to the caam crypto engine
directly before submission to the job ring. (including SGT, shared desc, job desc, and some helpful
variables from the crypto req)

2) Also capturing the same dumps after a job completed (with error)

3) After the error happens always analyze if maybe something corrupted descriptor memory etc...
-> seems ok

4) Disassemble the descriptors + SGT and check if they are as expected according to the crypto
operation.
The shared desc programs look ok (like the cnstr_shdsc_skcipher_{encap,decap} should have produced
them). I especially looked at the length parameters for the job descriptor SEQ IN PTR and SEQ OUT PTR
commands and compared it to the SGT entries. Everything seems to match up.

5) Tested a modification to the code that creates the SGT for caam DMA. I suspected that maybe
the missing final bit may cause problems.
I changed the code, so that the f (final) bit is at the correct position for both the SEQ IN PTR and
SEQ OUT PTR SGT:

Before:
00 ptr=16f25200, len=16, offset=0, extension=0, final=0  <- SEQ IN PTR
01 ptr=16e0c000, len=640, offset=0, extension=0, final=0
02 ptr=2d3a0d34, len=640, offset=0, extension=0, final=0 <- SEQ OUT PTR
03 ptr=16f25200, len=16, offset=0, extension=0, final=1
04 ptr=00000000, len=0, offset=0, extension=0, final=0
05 ptr=00000000, len=0, offset=0, extension=0, final=0

After:
00 ptr=16f25200, len=16, offset=0, extension=0, final=0  <- SEQ IN PTR
01 ptr=16e0c000, len=640, offset=0, extension=0, final=1
02 ptr=2d3a0d34, len=640, offset=0, extension=0, final=0 <- SEQ OUT PTR
03 ptr=16f25200, len=16, offset=0, extension=0, final=1
04 ptr=00000000, len=0, offset=0, extension=0, final=0
05 ptr=00000000, len=0, offset=0, extension=0, final=0

This did not affect the system in any way. Still the same errors approx with the same frequency of
occurrence.

6) Tested modifications to creating edesc, and dma mapping the different parts (skcipher_edesc_alloc):
I misappropriated some patches from the NXP kernel, and newer upstream kernels. Especially some fixes
for DMA alignment etc... They all seem to exist purely for aarch64 support, I tried them anyway.
Especially the alignment of the IV buffer at the end of the edesc, since the CAAM module will write
to it, and it might be dangerously close to some other memory there ;-).

-> All the changes I did here did not affect my test results at all. It still works like before,
the DECO errors happen in approx the same rate as before.

7) Tested a lot of modifications to the shared descriptors used for aes encrypt and decrypt
(cnstr_shdsc_skcipher_{encap,decap}):
Mostly I added some waits with JMP (like some of the other descriptors use), changed around the way
the variable length I/O for the ALGORITHM operation is calculated (skcipher_append_src_dst) etc...
My modifications changed behavior a bit, but I am still getting the same errors essentially.

Most of the time (like in the stock kernel) the errors I get are on the final SEQ STORE operation
that should write back the IV from the context register. When I get different errors, its probably
because of my modification (the desc index is different because of some extra waits). When I derive
the buffer length for the AES operation from SEQOUTLEN instead of SEQINLEN, the error will happen not
on the last SEQ STORE for the IV, but on the SEQ FIFO load for loading data into the input fifo.

This is a collection of some of my attempts (not complete, I just gathered the ones I commented
out here):

```C
#define WAIT_CONDITIONS (JUMP_COND_NIFP | JUMP_COND_CALM | JUMP_COND_NIP | JUMP_COND_NOP | JUMP_COND_NCP)
static inline void skcipher_append_src_dst(u32 *desc, u32 ivsize)
{
	// Upstream kernel version:
	// append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
	// append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);

	// Do not use REG0, use ZERO instead for 0 constant:
	// append_math_add(desc, VARSEQOUTLEN, SEQINLEN, ZERO, CAAM_CMD_SZ);
	// append_math_add(desc, VARSEQINLEN, SEQINLEN, ZERO, CAAM_CMD_SZ);

	// Derive from SEQOUTLEN instead:
	// append_math_sub_imm_u32(desc, VARSEQOUTLEN, SEQOUTLEN, IMM, ivsize);
	// append_math_sub_imm_u32(desc, VARSEQINLEN, SEQOUTLEN, IMM, ivsize);

	// Use both SEQINLEN and SEQOUTLEN
	append_math_sub_imm_u32(desc, VARSEQOUTLEN, SEQOUTLEN, IMM, ivsize);
	append_math_add(desc, VARSEQINLEN, SEQINLEN, ZERO, CAAM_CMD_SZ);

	// Random wait, maybe it helps?
	u32 *wait_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL | WAIT_CONDITIONS);
	set_jump_tgt_here(desc, wait_cmd);

	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);
	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 |
			     KEY_VLF | FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
}

```

-> They all work approx the same, encrypt + decrypt is still done correctly, but I get the
same DECO "Invalid Sequence Command" error in about the same frequency as before.

By the way, whats up with the `append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);`
line? Is this just some oversight when refactoring (usage of REG0 instead of ZERO), or did I
misunderstand something about the code, and REG0 actually contains some important offset in
this case? Did not make any difference when switching between ZERO and REG0 for all my tests.

Is this a known problem with the CAAM crypto engine? Meaning, that the SEQ IN PTR / SEQ OUT PTR fifo
seems to end early, or that perhaps the SEQOUTLEN and SEQINLEN registers do not work in the way I
expect? Unfortunately the datasheet is not 100% clear on this, I just assume they are counters that
should show the remaining bytes in their respective sequences.

My next idea would be to add some more debugging code to the descriptor. E.g. writing the value of
SEQINLEN to a ring buffer in system memory every time the desc is executed. Then trying to match
that output with the error that will occur sometimes.

I hope somebody can help me with this / has some insights.

Thanks,
Roland Ruckerbauer


Stress test program:

```C++
#include <cassert>
#include <chrono>
#include <cstring>
#include <format>
#include <inttypes.h>
#include <iostream>
#include <linux/if_alg.h>
#include <linux/socket.h>
#include <random>
#include <sys/random.h>
#include <sys/socket.h>
#include <thread>
#include <unistd.h>
#include <vector>
#include <errno.h>

using namespace std::chrono_literals;
namespace chrono = std::chrono;

constexpr size_t IV_LEN = 16;
constexpr chrono::duration ACTIVE_PERIOD = 2s;
constexpr chrono::duration PAUSE_PERIOD = 5ms;
constexpr int NUM_THREADS = 10;

void generate_key(char *out, size_t len) { getrandom(out, len, 0); }

void worker() {
  int ret;
  struct sockaddr_alg sa = {
      .salg_family = AF_ALG, .salg_type = "skcipher", .salg_name = "cbc(aes)"};

  int fd = socket(AF_ALG, SOCK_SEQPACKET, 0);
  bind(fd, (struct sockaddr *)&sa, sizeof(sa));

  char key[IV_LEN];
  generate_key(key, sizeof(key));

  setsockopt(fd, SOL_ALG, ALG_SET_KEY, key, sizeof(key));

  char message[4096];
  char buf[4096];
  size_t message_len = 0;
  generate_key(message, sizeof(message));

  int opfd = accept(fd, nullptr, 0);

  std::random_device r;
  std::default_random_engine e(r());
  std::uniform_int_distribution<int> uniform_dist_bool(0, 1);
  std::uniform_int_distribution<int> uniform_dist(512 / IV_LEN, 4096 / IV_LEN);
  // std::uniform_int_distribution<int> uniform_dist(16 / IV_LEN, 10 * 16 / IV_LEN);

  for (;;) {
    auto start = chrono::steady_clock::now();

    message_len = uniform_dist(e) * IV_LEN;

    std::cout << std::format("Start burst of {} with message len {}\n", ACTIVE_PERIOD, message_len);

    while (chrono::steady_clock::now() < start + ACTIVE_PERIOD) {
      struct msghdr msg = {};

      char cbuf[CMSG_SPACE(sizeof(uint32_t)) +
                CMSG_SPACE(IV_LEN + sizeof(af_alg_iv))] = {0};

      msg.msg_control = cbuf;
      msg.msg_controllen = sizeof(cbuf);

      struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg);
      cmsg->cmsg_level = SOL_ALG;
      cmsg->cmsg_type = ALG_SET_OP;
      cmsg->cmsg_len = CMSG_LEN(sizeof(uint32_t));
      *(uint32_t *)CMSG_DATA(cmsg) =
          (uniform_dist(e) == 0) ? ALG_OP_ENCRYPT : ALG_OP_DECRYPT;

      cmsg = CMSG_NXTHDR(&msg, cmsg);
      cmsg->cmsg_level = SOL_ALG;
      cmsg->cmsg_type = ALG_SET_IV;
      cmsg->cmsg_len = CMSG_LEN(IV_LEN + sizeof(af_alg_iv));
      struct af_alg_iv *iv = (struct af_alg_iv *)CMSG_DATA(cmsg);

      iv->ivlen = IV_LEN;
      generate_key((char *)iv->iv, IV_LEN);

      struct iovec iov = {0};
      iov.iov_base = message;

      iov.iov_len = message_len;

      msg.msg_iov = &iov;
      msg.msg_iovlen = 1;

      assert(sendmsg(opfd, &msg, 0) == message_len);

      if ((ret = read(opfd, buf, message_len)) != message_len) {
        if (ret < 0) {
          perror("reading from AF_ALG socket");
        } else {
          std::cout << std::format("Unexpected ret len {}, expected {}\n", ret, message_len);
        }
        abort();
      }
    }

    std::cout << std::format("Pause for {}\n", PAUSE_PERIOD);
    std::this_thread::sleep_for(PAUSE_PERIOD);
  }
}

int main() {
  std::vector<std::thread> join_handles;

  for (int i = 0; i < NUM_THREADS; ++i) {
    join_handles.emplace_back(worker);
  }

  while (!join_handles.empty()) {
    join_handles.back().join();
    join_handles.pop_back();
  }

  return 0;
}
```


Small tool I created for helping me understand descriptors / SGT when I dump them from memory
(you probably have better tools anyway):

```python
#!/bin/env python3

from argparse import ArgumentParser
from pathlib import Path
import struct
import functools
import math


class Program():
    def __init__(self, path):
        with Path(path).open("rb") as f:
            self.data = f.read()
            if len(self.data) % 4 != 0:
                raise Exception("program size not multiple of word size")
            self.cursor = 0

    def len_words(self):
        return int(len(self.data) / 4)

    def peek(self):
        if self.cursor >= self.len_words():
            return None

        return struct.unpack("<I", self.data[self.cursor * 4:(self.cursor + 1) * 4])[0]

    def data_at_cursor(self):
        return self.data[self.cursor * 4:]

    def seek(self, offset):
        self.cursor += offset

    def pos(self):
        return self.cursor

    def set_len(self, len):
        self.data = self.data[0:len * 4]


def get_bits(val, start, end):
    return (val >> start) & ((1 << (end - start + 1)) - 1)


def handle_field(res, header, name, start, end):
    res[name] = get_bits(header, start, end)


def decode_header(shared, program):
    fields = [
        ("ctype", 27, 31),
        ("desclen", 0, 6),
        ("share", 8, 10 if not shared else 9),
        ("reo" if not shared else "pd", 11, 11),
        ("shr" if not shared else "sc", 12, 12),
        ("mtd" if not shared else "cif", 13, 13),
        ("zro", 15, 15),
        ("one", 23, 23),
        ("dnr", 24, 24),
        ("rsms" if not shared else "rif", 25, 25),
    ]

    res = dict()

    header = program.peek()

    def hf(name, start, end): return handle_field(
        res, header, name, start, end)

    for field in fields:
        hf(*field)

    hf("start index" if shared or res["shr"]
       == 0 else "shr descr length", 16, 21)
    if not shared:
        hf("td", 14, 14)

    print(f"{program.pos():02} program header: {res}")
    program.seek(1)

    if not shared and res["shr"] == 1:
        print(f"{program.pos():02} shared desc pointer: 0x{program.peek():08x}")
        program.seek(1)

    # set program len
    program.set_len(res["desclen"])


def decode_key(seq, program):
    val = program.peek()
    startpos = program.pos()
    program.seek(1)
    name = "seq key" if seq else "key"

    fields = [
        ("length", 0, 9),
        ("tk", 15, 15),
        ("kdest", 16, 19),
        ("ekt", 20, 20),
        ("nwb", 21, 21),
        ("enc", 22, 22),
        ("imm", 23, 23),
        ("sgf", 24, 24),
        ("class", 25, 26),
    ]

    res = dict()
    def hf(name, start, end): return handle_field(res, val, name, start, end)
    for field in fields:
        hf(*field)

    if res["imm"] == 1:
        # Immediate value
        lenwords = math.ceil(res["length"] / 4)
        immval = program.data_at_cursor()[:lenwords * 4]
        res["immval"] = immval
        program.seek(lenwords)
    else:
        res["pointer"] = program.peek()
        program.seek(1)

    print(f"{startpos:02} {name}: {res}")


def decode_load(seq, program):
    val = program.peek()
    startpos = program.pos()
    program.seek(1)

    name = "seq load" if seq else "load"

    fields = [
        ("length", 0, 7),
        ("offset", 8, 15),
        ("dst", 16, 22),
        ("imm", 23, 23),
        ("vlf" if seq else "sgf", 24, 24),
        ("class", 25, 26),
    ]

    res = dict()
    def hf(name, start, end): return handle_field(res, val, name, start, end)
    for field in fields:
        hf(*field)

    if res["imm"] == 1 and seq:
        raise Exception("invalid encoding")
    elif res["imm"] == 1 and not seq:
        lenwords = math.ceil(res["length"] / 4)
        immval = program.data_at_cursor()[:lenwords * 4]
        res["immval"] = immval
        program.seek(lenwords)
    elif res["imm"] == 0 and not seq:
        res["pointer"] = program.peek()
        program.seek(1)
    # if seq and imm == 0 no extra words needed

    print(f"{startpos:02} {name}: {res}")


def decode_fifo_load(seq, program):
    val = program.peek()
    startpos = program.pos()
    program.seek(1)

    name = "seq fifo load" if seq else "fifo load"

    fields = [
        ("length", 0, 15),
        ("input data type", 16, 21),
        ("ext", 22, 22),
        ("imm", 23, 23),
        ("vlf" if seq else "sgf", 24, 24),
        ("class", 25, 26),
    ]

    res = dict()
    def hf(name, start, end): return handle_field(res, val, name, start, end)
    for field in fields:
        hf(*field)

    if res["imm"] == 0 and not seq:
        res["pointer"] = program.peek()
        program.seek(1)

    if res["ext"] == 1:
        res["extlength"] = program.peek()
        program.seek(1)

    print(f"{startpos:02} {name}: {res}")


def decode_store(seq, program):
    val = program.peek()
    startpos = program.pos()
    program.seek(1)
    name = "seq store" if seq else "store"

    fields = [
        ("class", 25, 26),
        ("vlf" if seq else "sgf", 24, 24),
        ("imm", 23, 23),
        ("src", 16, 22),
        ("offset", 8, 15),
        ("length", 0, 7),
    ]

    res = dict()

    def hf(name, start, end): return handle_field(
        res, val, name, start, end)

    for field in fields:
        hf(*field)

    if (not seq) or res["src"] not in [0x41, 0x42]:
        res["pointer"] = program.peek()
        program.seek(1)

    if res["imm"] == 1:
        lenwords = math.ceil(res["length"] / 4)
        res["immval"] = program.data_at_cursor()[:lenwords * 4]
        program.seek(lenwords)

    print(f"{startpos:02} {name}: {res}")


def decode_fifo_store(seq, program):
    val = program.peek()
    startpos = program.pos()
    program.seek(1)

    fields = [
        ("length", 0, 15),
        ("output data type", 16, 21),
        ("ext", 22, 22),
        ("cont", 23, 23),
        ("vlf" if seq else "sgf", 24, 24),
        ("aux", 25, 26),
    ]

    res = dict()
    def hf(name, start, end): return handle_field(res, val, name, start, end)
    for field in fields:
        hf(*field)

    if not seq:
        res["pointer"] = program.peek()
        program.seek(1)

    if res["ext"] == 1:
        res["extlength"] = program.peek()
        program.seek(1)

    name = "seq fifo store" if seq else "fifo store"
    print(f"{startpos:02} {name}: {res}")


def decode_move(program):
    val = program.peek()
    name = "move"
    print(f"{program.pos():02} {name}")
    program.seek(1)


def decode_signature(program):
    val = program.peek()
    name = "signature"
    print(f"{program.pos():02} {name}")
    program.seek(1)


def decode_jump(program):
    val = program.peek()
    startpos = program.pos()
    program.seek(1)

    name = "jump"

    fields = [
        ("class", 25, 26),
        ("jsl", 24, 24),
        ("jump type", 21, 23),
        ("test type", 16, 17),
        ("test condition", 8, 15),
    ]

    res = dict()

    def hf(name, start, end): return handle_field(res, val, name, start, end)

    for field in fields:
        hf(*field)

    if res["jump type"] in [0b001, 0b011]:
        res["pointer"] = program.peek()
        program.seek(1)
    else:
        hf("local offset", 0, 7)

    print(f"{startpos:02} {name}: {res}")


def decode_math(program):
    val = program.peek()
    startpos = program.pos()
    program.seek(1)
    name = "math"

    fields = [
        ("len", 0, 3),
        ("dest", 8, 11),
        ("src1", 12, 15),
        ("src0", 16, 19),
        ("function", 20, 23),
        ("stl", 24, 24),
        ("nfu", 25, 25),
        ("ifb", 26, 26),
    ]

    res = dict()
    def hf(name, start, end): return handle_field(res, val, name, start, end)
    for field in fields:
        hf(*field)

    if res["src0"] == 0b0100:
        immlen = math.ceil(res["len"] / 4) if res["ifb"] != 1 else 1
        res["src0immval"] = struct.unpack(
            f"<{'I' if immlen == 1 else 'Q'}", program.data_at_cursor()[:immlen * 4])[0]
        program.seek(immlen)

    if res["src1"] == 0b0100:
        immlen = math.ceil(res["len"] / 4) if res["ifb"] != 1 else 1
        res["src1immval"] = struct.unpack(
            f"<{'I' if immlen == 1 else 'Q'}", program.data_at_cursor()[:immlen * 4])[0]
        program.seek(immlen)

    print(f"{startpos:02} {name}: {res}")


def decode_algo_op(program):
    name = "algorithm operation"

    fields = [
        ("optype", 24, 26),
        ("alg", 16, 23),
    ]

    not_rng_fields = [
        ("aai", 4, 12),
        ("as", 2, 3),
        ("icv", 1, 1),
        ("enc", 0, 0),
    ]

    rng_fields = [
        ("sk", 12, 12),
        ("ai", 11, 11),
        ("ps", 10, 10),
        ("obp", 9, 9),
        ("nzb", 8, 8),
        ("sh", 4, 5),
        ("as", 2, 3),
        ("pr", 1, 1),
        ("tst", 0, 0),
    ]

    val = program.peek()

    res = dict()
    def hf(name, start, end): return handle_field(res, val, name, start, end)
    for field in fields:
        hf(*field)

    if res["optype"] == 0x2 and res["alg"] == 0x50:
        more = rng_fields
    else:
        more = not_rng_fields

    for field in more:
        hf(*field)

    print(f"{program.pos():02} {name}: {res}")
    program.seek(1)


def decode_protocol_op(program):
    name = "protocol operation"
    print(f"{program.pos():02} {name}")
    program.seek(1)


def decode_operation(program):
    val = program.peek()

    optype = get_bits(val, 24, 26)
    match optype:
        case 0b010 | 0b100: decode_algo_op(program)
        case 0b000 | 0b110 | 0b111: decode_protocol_op(program)


def decode_seq_in_ptr(program):
    fields = [
        ("rjd", 20, 20),
        ("rto", 21, 21),
        ("ext", 22, 22),
        ("pre", 23, 23),
        ("sgf", 24, 24),
        ("inl", 25, 25),
    ]

    res = dict()
    val = program.peek()

    def hf(name, start, end): return handle_field(res, val, name, start, end)

    for field in fields:
        hf(*field)

    startpos = program.pos()
    program.seek(1)

    if res["pre"] == 0 and res["rto"] == 0:
        res["pointer"] = program.peek()
        program.seek(1)

    if res["ext"] == 1:
        res["ext length"] = program.peek()
        program.seek(1)
    else:
        hf("length", 0, 15)

    name = "seq in ptr"
    print(f"{startpos:02} {name}: {res}")


def decode_seq_out_ptr(program):
    fields = [
        ("rto", 21, 21),
        ("ext", 22, 22),
        ("pre", 23, 23),
        ("sgf", 24, 24),
    ]

    res = dict()
    val = program.peek()

    def hf(name, start, end): return handle_field(res, val, name, start, end)

    for field in fields:
        hf(*field)

    startpos = program.pos()
    program.seek(1)

    if res["pre"] == 0 and res["rto"] == 0:
        res["pointer"] = program.peek()
        program.seek(1)

    if res["ext"] == 1:
        res["ext length"] = program.peek()
        program.seek(1)
    else:
        hf("length", 0, 15)

    name = "seq out ptr"
    print(f"{startpos:02} {name}: {res}")


CTYPE2DEC = {
    0b00000: functools.partial(decode_key, False),
    0b00001: functools.partial(decode_key, True),
    0b00010: functools.partial(decode_load, False),
    0b00011: functools.partial(decode_load, True),
    0b00100: functools.partial(decode_fifo_load, False),
    0b00101: functools.partial(decode_fifo_load, True),
    0b01010: functools.partial(decode_store, False),
    0b01011: functools.partial(decode_store, True),
    0b01100: functools.partial(decode_fifo_store, False),
    0b01101: functools.partial(decode_fifo_store, True),
    0b10000: decode_operation,
    0b10010: decode_signature,
    0b10100: decode_jump,
    0b10101: decode_math,
    0b11110: decode_seq_in_ptr,
    0b11111: decode_seq_out_ptr,
}


def decode_descriptor(args):
    program = Program(args.filename)

    print(f"program len: {program.len_words()} words")

    header = decode_header(args.shared, program)

    while (word := program.peek()) is not None:
        # print(word)
        ctype = get_bits(word, 27, 31)
        decoder = CTYPE2DEC.get(ctype)

        if decoder is None:
            print(f"{program.pos():02} ctype 0b{ctype:b}: unsupported")
            program.seek(1)
        else:
            decoder(program)


def decode_sgt(args):
    with Path(args.filename).open("rb") as f:
        sgtbuf = f.read()
        if len(sgtbuf) % 16:
            raise Exception("sgt not multiple of 16 bytes")

        offset = 0

        while offset < len(sgtbuf) / 16:
            _reserved, ptr, l, bpid_offset = struct.unpack(
                "<IIII", sgtbuf[offset*16:(offset + 1) * 16])

            extension = get_bits(l, 31, 31)
            final = get_bits(l, 30, 30)
            l = get_bits(l, 0, 29)

            print(f"{offset:02} ptr={ptr:08x}, len={
                  l}, offset={bpid_offset}, extension={extension}, final={final}")
            offset += 1


def main():
    parser = ArgumentParser(
        prog="descdisassm", description="Disassemble CAAM descriptors")
    parser.add_argument("filename")
    parser.add_argument(
        "-s", "--shared", help="This is a shared descriptor", action="store_true")
    parser.add_argument("-t", "--sgt", help="This is a SGT",
                        action="store_true")
    args = parser.parse_args()

    if not args.sgt:
        decode_descriptor(args)
    else:
        decode_sgt(args)


if __name__ == "__main__":
    main()
```
