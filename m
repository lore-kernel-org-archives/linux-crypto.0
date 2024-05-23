Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602131170F;
	Thu, 23 May 2024 15:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716476513; cv=none; b=OT+2KIDziOKHemeuO/qEryfwk5WQ3TLNv/YRs5cdpJVNmZLnj7DNJF7lpHtA/fftFhuuVVQbQdq6eKNyTScuU5YwXUXlOlyOE0q8aTCLnOGU7aCQ3CKdHbVVMpE/JksbQNMKnwaudyfzDvFIQzyZ6+p3ekZSo+PjjsmYd2mpe0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716476513; c=relaxed/simple;
	bh=gcY/hpUgGlbWTO7iFEHxWUYAgr45cIvkuGeBIW4nKhU=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject; b=PB+FXWbaHNnXaG7cMWFUEHLQbobtH7c9CssPTIgVQAAkG6irlPxHWz2Wu2fPs4sZrSb2r6SNu5h9+Xg3GMNy8U9XtJuaypM+bhKjdG72xaV3viNe8tnzgLJ+G8rjBhtCPuQavn0J1I7TZBUZn6ctC79NNlLbgKPCkwbOtr4YZFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pFRp+sUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pFRp+sUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0910C4AF50;
	Thu, 23 May 2024 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716476513;
	bh=gcY/hpUgGlbWTO7iFEHxWUYAgr45cIvkuGeBIW4nKhU=;
	h=Date:From:To:Cc:Subject:From;
	b=pFRp+sUaL6h39QAKlKhUGL4spDcoS7nRBaqqesiCJDG5stqrQmhVBqvI7SP4A7D0t
	 vH7dYN9B7zvTI0coiNtpYUgQy9U1LdV4XZrG/K7pe48ZengVlRR6jzTjpueXfHgJz2
	 d92zwuVHgEU/ZxS7JNrb6EjWLb2NGeQP7R+TOv88/FjuScwRJq0BgaxEoqh/2HBQR/
	 4/8acQvGVMI7A4Sfu3oaOnqYaS6xViHLSLlaMrbvJaCuYPxw4qHQbafgKyI+w1fbJM
	 S3DPtAGKdx5n87qclQoRwc/1MrjVfWYrAfHxL5ZhUn/RyAOtyFiQpm3dyf07dqvB+0
	 dRwv5FkEhOJ8A==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 May 2024 18:01:49 +0300
Message-Id: <D1H452IHSLRC.1WZSPJQLCD5RD@kernel.org>
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: <linux-modules@vger.kernel.org>
Cc: "Luis Chamberlain" <mcgrof@kernel.org>, "Linus Torvalds"
 <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Subject: is_module()
X-Mailer: aerc 0.17.0

Hi,

I just put this here while I still have it on my mind. Possibly I'm
ignoring something that already enables this but at least I learn
something by doing this then.=20

This came up in a recent discussion albeit for this crypto bug it
did not make waves because the bug fix did not require it:

https://lore.kernel.org/linux-integrity/D1GXKODMD4S8.1J12D4GOEQWPL@kernel.o=
rg/

So the gist of  is_module() would be that it would have different
semantics than IS_MODULE(): it could be used to e.g. check modules in a
loop.

Compilation would generate a new ELF section with following entries:

<ASCIIZ string><0 or 1>

The string would contain module name, and 1 could be marking for
being a module, and 0 for being builtin.

Also, it would enabled to add lsmod -b to enumerate built-in modules,
which would give nice way to carve up more information about a running
test kernel. This would obviously need perhaps a new file to procfs for
built-in modules (for regular there is /proc/modules).

Not fighting for having this, just makig it visible.

BR, Jarkko
